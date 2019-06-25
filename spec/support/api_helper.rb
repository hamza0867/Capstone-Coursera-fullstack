# frozen_string_literal: true

module ApiHelper
  def parsed_body
    JSON.parse(response.body)
  end

  def signup(registration, status = :ok)
    post user_registration_path, params: registration.to_json,
                                 headers: { 'Content-Type' => 'application/json' }
    expect(response).to have_http_status(status)
  end
end

RSpec.shared_examples 'resource index' do |model|
  let!(:resources) { (1..5).map { |_idx| FactoryGirl.create(model) } }
  let(:payload) { parsed_body }

  it "returns all #{model} instances" do
    get send("#{model}s_path"), headers: { 'Accept' => 'application/json' }
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
    get send("#{model}_path", resource.id)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    response_check if respond_to?(:response_check)
  end

  it 'returns not found when using incorrect ID' do
    get send("#{model}_path", bad_id)
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
    post send("#{model}s_path"), params: resource_state.to_json,
                                 headers: { 'Content-Type' => 'application/json' }
    expect(response).to have_http_status(:created)
    expect(response.content_type).to eq('application/json')

    # verify payload has ID and delegate for addition checks
    expect(payload).to have_key('id')
    response_check if respond_to?(:response_check)

    # verify we can locate the created instance in DB
    get send("#{model}_path", resource_id)
    expect(response).to have_http_status(:ok)
  end
end

RSpec.shared_examples 'modifiable resource' do |model|
  let(:resource) do
    post send("#{model}s_path"), params: FactoryGirl.attributes_for(model).to_json,\
                                 headers: { 'Content-Type' => 'application/json' }
    expect(response).to have_http_status(:created)
    parsed_body
  end
  let(:new_state) { FactoryGirl.attributes_for(model) }

  it "can update #{model}" do
    # change to new state
    put send("#{model}_path", resource['id']), params: new_state.to_json,\
                                               headers: { 'Content-Type' => 'application/json' }
    expect(response).to have_http_status(:ok)

    update_check if respond_to?(:update_check)
  end

  it 'can be deleted' do
    head send("#{model}_path", resource['id'])
    expect(response).to have_http_status(:ok)

    delete send("#{model}_path", resource['id'])
    expect(response).to have_http_status(:no_content)

    head send("#{model}_path", resource['id'])
    expect(response).to have_http_status(:not_found)
  end
end
