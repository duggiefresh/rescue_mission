require 'rails_helper'

describe API::V1::QuestionsController do
  describe "GET #index" do
    it "returns all the questions, ordered by recency" do
      older_question = FactoryGirl.create(:question,
        created_at: Time.zone.now - 1.week)
      old_question = FactoryGirl.create(:question,
        created_at: Time.zone.now - 1.day)
      oldest_question = FactoryGirl.create(:question,
        created_at: Time.zone.now - 1.year)
      ordered_questions = [old_question, older_question, oldest_question]

      get :index

      expect(json).to be_json_eq(
        ActiveModel::ArraySerializer.new(ordered_questions, root: :questions)
      )
    end
  end

  describe "GET #show" do
    it "returns a question" do
      question = FactoryGirl.create(:question)
      serialized_question = QuestionSerializer.new(question,
        include: [:user, :answers, :comments])

      get :show, id: question.id

      expect(json).to be_json_eq serialized_question
    end
  end

  describe "POST #create" do
    context "with valid access token" do
      let(:api_key) { FactoryGirl.create(:api_key) }
      let(:current_user) { api_key.user }

      before do
        mock_authentication_with(api_key)
      end

      context "with valid attributes" do
        it "creates a new question" do
          question_attributes = FactoryGirl.attributes_for(:question)
          expect(Question.count).to eq 0

          post :create, question: question_attributes

          expect(Question.count).to eq 1
          expect(response.status).to eq 201
          expect(json).to be_json_eq QuestionSerializer.new(Question.first, scope: current_user)
        end
      end

      context "with invalid attributes" do
        it "is not successful" do
          post :create, question: { invalid: '' }

          expect(response.status).to eq 422
        end
      end
    end

    it "requires authentication" do
      post :create, question: { derp: 'mcderp' }

      expect(response.status).to eq 401
    end
  end

  describe "PUT #update" do
    context "with valid access token" do
      let(:api_key) { FactoryGirl.create(:api_key) }
      let(:current_user) { api_key.user }

      before do
        mock_authentication_with(api_key)
      end

      context "when question belongs to current user" do
        context "with valid attributes" do
          it "updates the question" do
            question = FactoryGirl.create(:question,
              user: current_user,
              title: "I am just a troll")

            expect {
              put :update, id: question.id, question: { title: "Just kidding, I'm not a troll" }
            }.to_not change{Question.count}

            question.reload
            expect(response.status).to eq 200
            expect(json).to be_json_eq QuestionSerializer.new(question, scope: current_user)
            expect(question.title).to eq "Just kidding, I'm not a troll"
          end
        end

        context "with invalid attributes" do
          it "is not successful" do
            question = FactoryGirl.create(:question, user: current_user)

            put :update, id: question.id, question: { title: '' }

            expect(response.status).to eq 422
          end
        end
      end

      context "when question belongs to another user" do
        it "doesn't update the question" do
          question = FactoryGirl.create(:question)

          expect {
            put :update, id: question.id, question: { company: 'Trollcat' }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context "without valid access token" do
      it "is unauthorized" do
        put :update, id: 'anything'

        expect(response.status).to eq 401
      end
    end
  end
end
