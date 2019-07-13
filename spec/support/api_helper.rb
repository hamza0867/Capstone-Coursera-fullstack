# frozen_string_literal: true

module ApiHelper
  def parsed_body
    JSON.parse(response.body)
  end

  # automates the passing of payload bodies as json
  %w[post put patch get head delete].each do |http_method_name|
    define_method("j#{http_method_name}") do |path, params: {}, headers: {}|
      if %w[post put patch].include? http_method_name
        headers = headers.merge('content-type' => 'application/json') unless params.empty?
        params = params.to_json
      end
      send(http_method_name,
           path,
           params: params,
           headers: headers.merge(access_tokens))
    end
  end

  def signup(registration, status = :ok)
    jpost user_registration_path, params: registration
    expect(response).to have_http_status(status)
    payload = parsed_body
    return payload unless response.ok?

    registration.merge(id: payload['data']['id'],
                       uid: payload['data']['uid'])
  end

  def login(credentials, status = :ok)
    post user_session_path,
         params: credentials.slice(:email, :password).to_json,
         headers: { 'Content-Type' => 'application/json' }
    expect(response).to have_http_status(status)
    response.ok? ? parsed_body['data'] : parsed_body
  end

  def access_tokens?
    response.headers['access-token'].present? if response
  end

  def access_tokens
    if access_tokens?
      @last_tokens = %w[uid client token-type access-token].each_with_object({}) { |k, h| h[k] = response.headers[k]; }
    end
    @last_tokens || {}
  end

  def logout(status = :ok)
    delete destroy_user_session_path, headers: access_tokens
    @last_tokens = {}
    expect(response).to have_http_status(status) if status
  end

  def create_resource(path, factory, status = :created)
    jpost path, params: FactoryGirl.attributes_for(factory)
    expect(response).to have_http_status(status) if status
    parsed_body
  end
end

RSpec.shared_examples 'resource index' do |model|
  let!(:resources) { (1..5).map { |_idx| FactoryGirl.create(model) } }
  let(:payload) { parsed_body }

  it "returns all #{model} instances" do
    jget send("#{model}s_path")
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')

    expect(payload.count).to eq(resources.count)
    response_check if respond_to?(:response_check)
  end
end

RSpec.shared_examples 'show resource' do |model|
  let(:resource) { FactoryGirl.create(model) }
  let(:payload) { parsed_body }
  let(:bad_id) { 1_234_567_890 }

  it "returns #{model} when using correct ID" do
    jget send("#{model}_path", resource.id)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    response_check if respond_to?(:response_check)
  end

  it 'returns not found when using incorrect ID' do
    jget send("#{model}_path", bad_id)
    expect(response).to have_http_status(:not_found)
    expect(response.content_type).to eq('application/json')

    payload = parsed_body
    expect(payload).to have_key('errors')
    expect(payload['errors']).to have_key('full_messages')
    expect(payload['errors']['full_messages'][0]).to include('cannot',\
                                                             bad_id.to_s)
  end
end

RSpec.shared_examples 'create resource' do |model|
  let(:resource_state) { FactoryGirl.attributes_for(model) }
  let(:payload)        { parsed_body }
  let(:resource_id)    { payload['id'] }

  it "can create valid #{model}" do
    jpost send("#{model}s_path"), params: resource_state
    expect(response).to have_http_status(:created)
    expect(response.content_type).to eq('application/json')

    # verify payload has ID and delegate for addition checks
    expect(payload).to have_key('id')
    response_check if respond_to?(:response_check)

    # verify we can locate the created instance in DB
    jget send("#{model}_path", resource_id)
    expect(response).to have_http_status(:ok)
  end
end

RSpec.shared_examples 'modifiable resource' do |model|
  let(:resource) do
    jpost send("#{model}s_path"), params: FactoryGirl.attributes_for(model)
    expect(response).to have_http_status(:created)
    parsed_body
  end
  let(:new_state) { FactoryGirl.attributes_for(model) }

  it "can update #{model}" do
    # change to new state
    jput send("#{model}_path", resource['id']), params: new_state
    expect(response).to have_http_status(:ok)

    update_check if respond_to?(:update_check)
  end

  it 'can be deleted' do
    jhead send("#{model}_path", resource['id'])
    expect(response).to have_http_status(:ok)

    delete send("#{model}_path", resource['id']), headers: access_tokens
    expect(response).to have_http_status(:no_content)

    jhead send("#{model}_path", resource['id'])
    expect(response).to have_http_status(:not_found)
  end
end
