class CloudApp
  def initialize name
  	@app = Cloud.find_by_name name
  	connect unless @app.token.present?
  end

  def connected?
  	@app.token.present?
  end

  def tts text
  	response = send_request '/api/v1/speeches/tts', 'post', {token: @app.token, text: text}
  	if response && response.is_a?(Hash) && response['url'].present?
  	  response['url']
  	else
      error_message
  	end
  end

  private

  def connect
    response = send_request '/api/v1/oauth/login', 'put', {name: @app.user, password: @app.password}
    if response && response.is_a?(Hash) && response['token'].present?
      @app.token = response['token']
      @app.save
    end 
  end

  def send_request url, type, data
  	uri = URI(@app.host + url)
	req = http_factory(type).new(uri, 'Content-Type' => 'application/json')
	req.body = data.to_json if data.present?
	response = Net::HTTP.start(uri.hostname, uri.port) do |http|
	  http.request(req)
	end
	response && response.present? && response.body.present? && JSON.parse(response.body) || nil
  end

  def http_factory type
  	_type = 'Net::HTTP::' + type.capitalize
  	_type.split('::').inject(Object) {|o,c| o.const_get c}
  end

  def error_message
  	'http://amber-cloud.space/tts/error.wav'
  end

end

#Cloud.new(host: "http://amber-cloud.space", name: "amber-cloud", user: "andriikostyk", password: "gray000")
#app = CloudApp.new('amber-cloud')