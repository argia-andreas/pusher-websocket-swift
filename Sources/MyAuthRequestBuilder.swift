import Foundation 

@objcMembers
@objc(MyAuthRequestBuilder) public class MyAuthRequestBuilder: NSObject & AuthRequestBuilderProtocol {
    public var authEndpoint: String
    public var authHeaders: NSDictionary? = nil
    public var authParams: NSDictionary? = nil

    @objc required public init(authEndpoint: String, authHeaders: NSDictionary? = nil, authParams: NSDictionary? = nil) {
        self.authEndpoint = authEndpoint
        self.authHeaders = authHeaders
        self.authParams = authParams
    }

   @objc func requestFor(socketID: String, channelName: String) -> URLRequest? {

        var endpointUrl = self.authEndpoint
        var stringKey = ""
        var stringValue = ""

        
        var i = 0
        // Add auth params
        if(self.authParams != nil) {
            for (key, value) in self.authParams! {
                stringKey = key as! String
                stringValue = value as! String

                if(i == 0) {
                    endpointUrl += "?" + stringKey + "=" + stringValue
                } else {
                    endpointUrl += "&" + stringKey + "=" + stringValue 
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
        
        return request
    }
}