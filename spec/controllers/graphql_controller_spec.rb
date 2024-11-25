require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_token) { JwtService.encode(user_id: user.id) }
  let(:invalid_token) { 'invalid.token' }
  let(:public_query) { 'mutation loginUser { loginUser(input: {email: "test@example.com", password: "password"}) { token } }' }
  let(:protected_query) { 'query { tasks { id title } }' }

  before do
    allow(JwtService).to receive(:decode).and_return({ user_id: user.id })
  end

  describe 'POST #execute' do
    context 'when the query is a public mutation' do
      it 'does not require authentication' do
        post :execute, params: { query: public_query }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the query is protected' do
      context 'with a valid token' do
        before do
          request.headers['Authorization'] = "Bearer #{valid_token}"
        end

        it 'authenticates the user and processes the query' do
          post :execute, params: { query: protected_query }
          expect(response).to have_http_status(:ok)
          expect(controller.instance_variable_get(:@current_user)).to eq(user)
        end
      end

      context 'with an invalid token' do
        before do
          request.headers['Authorization'] = "Bearer #{invalid_token}"
          allow(JwtService).to receive(:decode).and_return(nil)
        end

        it 'returns an unauthorized error' do
          post :execute, params: { query: protected_query }
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq({ 'errors' => ['Not Authorized'] })
        end
      end

      context 'without a token' do
        before do
          allow(JwtService).to receive(:decode).and_return(nil)
        end
      
        it 'returns an unauthorized error' do
          post :execute, params: { query: protected_query }
          expect(response).to have_http_status(:unauthorized)
          body = JSON.parse(response.body)
          expect(body['errors']).to include('Not Authorized')
        end
      end
    end

    context 'when an error occurs during query execution' do
      before do
        allow_any_instance_of(GraphqlController).to receive(:authenticate_user!).and_return(true)
        allow(TodoGraphqlSchema).to receive(:execute).and_raise(StandardError, 'Something went wrong')
      end
    
      it 'handles the error in development' do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
    
        post :execute, params: { query: protected_query }
        expect(response).to have_http_status(500)
    
        body = JSON.parse(response.body)
        expect(body['errors']).to be_present
        expect(body['errors'].first['message']).to eq('Something went wrong')
      end
    end 

    context 'when an error occurs during query execution' do
      before do
        allow_any_instance_of(GraphqlController).to receive(:authenticate_user!).and_return(true)
        allow(TodoGraphqlSchema).to receive(:execute).and_raise(StandardError, 'Something went wrong')
      end
    
      it 'raises the error in production' do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
    
        expect {
          post :execute, params: { query: protected_query }
        }.to raise_error(StandardError, 'Something went wrong')
      end
    end    
  end

  describe '#set_cors_headers' do
    controller(GraphqlController) do
      def index
        render plain: 'OK'
      end
    end

    it 'sets CORS headers correctly' do
      get :index
      expect(response.headers['Access-Control-Allow-Origin']).to eq('http://localhost:5173')
      expect(response.headers['Access-Control-Allow-Methods']).to eq('GET, POST, PUT, PATCH, DELETE, OPTIONS')
      expect(response.headers['Access-Control-Allow-Headers']).to eq('Origin, Content-Type, Accept, Authorization')
      expect(response.headers['Access-Control-Allow-Credentials']).to eq('true')
    end
  end
end
