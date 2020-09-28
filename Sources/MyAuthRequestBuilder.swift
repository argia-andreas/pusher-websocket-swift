import Foundation 

@objcMembers
@objc(MyAuthRequestBuilder) public class MyAuthRequestBuilder: NSObject & AuthRequestBuilderProtocol {
    public var authEndpoint: String
    // public var bearerToken: String
    public var authHeaders: NSDictionary? = nil
    public var authParams: NSDictionary? = nil
    // public var headers: String
    // public var params: String
    // public var socketID: String
    // public var channelName: String

    @objc required public init(authEndpoint: String, authHeaders: NSDictionary? = nil, authParams: NSDictionary? = nil) {
        self.authEndpoint = authEndpoint
        self.authHeaders = authHeaders
        self.authParams = authParams
    }

   @objc func requestFor(socketID: String, channelName: String) -> URLRequest? {

        var endpointUrl = self.authEndpoint
        var stringKey = ""
        var stringValue = ""
        // Add auth params
        var i = 0
        if(self.authParams != nil) {
            for (key, value) in self.authParams! {
                stringKey = key as! String
                stringValue = value as! String

                if(i == 0) {
                    endpointUrl += "?"
                    endpointUrl += stringKey
                    endpointUrl += "="
                    endpointUrl += stringValue
                } else {
                    endpointUrl += "&"
                    endpointUrl += stringKey
                    endpointUrl +=  "="
                    endpointUrl += stringValue
                }
                i += 1
            }
        }

        var request = URLRequest(url: URL(string: endpointUrl)!)
        request.httpMethod = "POST"
        request.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)

        // Add auth headers
        if(self.authHeaders != nil) {
            for (key, value) in self.authHeaders! {
                stringKey = key as! String
                stringValue = value as! String
                request.addValue(stringValue, forHTTPHeaderField: stringKey)
            }
        }
        
        // request.addValue(self.bearerToken, forHTTPHeaderField: "Authorization")
        // request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}