import Foundation

final class OAuth2Service {    
    static let shared = OAuth2Service()
    private var lastCode: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    private init() {}

    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        assert(Thread.isMainThread)

        if lastCode == code { return }
        task?.cancel()
        lastCode = code

        let request = authTokenRequest(code: code)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResult, Error>) in

            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }

        }

        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectUri)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}

