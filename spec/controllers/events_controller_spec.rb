require 'rails_helper'
require "cancan/matchers"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe EventsController, :type => :controller do
  include Devise::TestHelpers

  let(:valid_session) {
  }
  let(:task) { create :task }
  let(:user) { create :user }

  let(:valid_attributes) {
    {name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date: (Time.now).strftime("%Y-%m-%d"),
    ends_at_date: (Time.now + 7200).strftime("%Y-%m-%d"),    # + 2h
    starts_at_time: (Time.now).strftime("%H:%M:%S"),
    ends_at_time: (Time.now + 7200).strftime("%H:%M:%S"),
    is_private: true,
    user_id: user.id
    }
  }
 
 let(:valid_attributes_for_request) {
    {name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date: (Time.now).strftime("%Y-%m-%d"),
    ends_at_date: (Time.now + 7200).strftime("%Y-%m-%d"),    # + 2h
    starts_at_time: (Time.now).strftime("%H:%M:%S"),
    ends_at_time: (Time.now + 7200).strftime("%H:%M:%S"),
    rooms: ["1", "2"], 
    is_private: true,
    user_id: user.id
    }
  }

  let(:valid_attributes_with_template_id_for_request) { 
    {name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date: (Time.now).strftime("%Y-%m-%d"),
    ends_at_date: (Time.now + 7200).strftime("%Y-%m-%d"),    # + 2h
    starts_at_time: (Time.now).strftime("%H:%M:%S"),
    ends_at_time: (Time.now + 7200).strftime("%H:%M:%S"),
    rooms: ["1", "2"], 
    is_private: true,
    user_id: user.id,
    event_template_id: 1
    }
  }

  let(:invalid_attributes) {
    {
    name:'Michas GB',
    starts_at_date:'2014-08-23',
    ends_at_date:'2014-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    user_id: user.id
	}
  }

  let(:invalid_attributes_for_request) {
    {
    name:'Michas GB',
    starts_at_date: (Date.today - 1),
    ends_at_date: Date.today,
    starts_at_time: Time.now.strftime("%H:%M:%S"),
    ends_at_time: Time.now.strftime("%H:%M:%S"),
    rooms:[],
    user_id: user.id
  }
  }

   let(:invalid_participant_count) {
    {name:'Michas GB',
   	participant_count:-100,
    starts_at_date: Time.now.strftime("%Y-%m-%d"),
    ends_at_date: (Time.now + 7200).strftime("%Y-%m-%d"),    # + 2h
    starts_at_time: Time.now.strftime("%H:%M:%S"),
    ends_at_time: (Time.now + 7200).strftime("%H:%M:%S"),
    user_id: user.id
    }
  }

  let(:invalid_participant_count_for_request) {
    {name:'Michas GB',
    participant_count:-100,
    starts_at_date: Time.now.strftime("%Y-%m-%d"),
    ends_at_date: (Time.now + 7200).strftime("%Y-%m-%d"),    # + 2h
    starts_at_time: Time.now.strftime("%H:%M:%S"),
    ends_at_time: (Time.now + 7200).strftime("%H:%M:%S"),
    rooms: [],
    user_id: user.id
    }
  }


  let(:invalid_attributes_for_event_suggestion) {
    {
      starts_at_date: (Date.today - 1).strftime("%Y-%m-%d"),
      ends_at_date: (Date.today - 1).strftime("%Y-%m-%d"),
      starts_at_time: Time.now.strftime("%H:%M:%S"),
      ends_at_time: Time.now.strftime("%H:%M:%S"),
      user_id: 122,
      original_event_id: 1
    }
  } 

  let(:valid_attributes_for_event_suggestion) {
    {
      starts_at_date: (Time.now + 1).strftime("%Y-%m-%d"),
      ends_at_date: (Time.now + 2).strftime("%Y-%m-%d"),
      starts_at_time: Time.now.strftime("%H:%M:%S"),
      ends_at_time: Time.now.strftime("%H:%M:%S"),
      user_id: 122,
      original_event_id: 1
    }
  }
  
  let(:not_conflicting_event) { 
    { 
      starts_at_date: (Time.now - 7200).strftime("%Y-%m-%d"),
      ends_at_date: (Time.now - 3600).strftime("%Y-%m-%d"),
      starts_at_time: (Time.now - 7200).strftime("%H:%M:%S"),
      ends_at_time: (Time.now - 3600).strftime("%H:%M:%S"),
      room_ids: ['1'], 
    }
  }

  let(:conflicting_event) { 
    { 
      starts_at_date: Time.now.strftime("%Y-%m-%d"),
      ends_at_date: (Time.now + 3600).strftime("%Y-%m-%d"),
      starts_at_time: Time.now.strftime("%H:%M:%S"),
      ends_at_time: (Time.now + 3600).strftime("%H:%M:%S"),
      room_ids: ['1'], 
    }
  }

  let(:not_conflicting_result) { 
    { :status => true }.to_json
  }

  let(:conflicting_result) { 
    { :status => false }.to_json
  }


  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "assigns all events as @events" do
      event = Event.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:events)).to eq([event])
    end
  end

  describe "GET show" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:event)).to eq(event)
    end

    it "assigns the tasks of the requested event as @tasks ordered by rank" do
      event = Event.create! valid_attributes
      firstTask = create(:task)
      firstTask.event = event
      firstTask.save

      secondTask = create(:task)
      secondTask.event = event
      secondTask.task_order_position = 0
      secondTask.save

      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:tasks)).to eq [secondTask, firstTask]
    end

    it "only shows tasks assigned to current user when he is not the event owner" do
      assigned_user = create(:user)
      sign_in assigned_user

      event = Event.create! valid_attributes
      firstTask = create(:task, event_id: event.id, identity: assigned_user)
      secondTask = create(:task, event_id: event.id)

      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:tasks)).to eq [firstTask]
    end

    it "shows all tasks of the event to the event owner" do
      assigned_user = create(:user)
      
      event = Event.create! valid_attributes
      firstTask = create(:task, event_id: event.id, identity: assigned_user)
      secondTask = create(:task, event_id: event.id)

      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:tasks)).to eq [firstTask, secondTask]
    end
  end

  describe "GET new" do
    it "assigns a new event as @event" do
      get :new, {}, valid_session
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe "GET new_event_suggestion" do
    it "creates a new event suggestion and assigns it as @event_suggestion" do 
      event = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event.to_param}, valid_session
      event_suggestion = assigns(:event)
      expect(event_suggestion.starts_at).to eq(event.starts_at)
      expect(event_suggestion.ends_at).to eq(event.ends_at)
      expect(event_suggestion.rooms).to eq(event.rooms)
      expect(event_suggestion.user_id).to eq(event.user_id)
    end

    it "stores the current event_id into the session" do 
      event = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event.to_param}, valid_session
      expect(assigns(:original_event_id).to_i).to eq(event.id)
    end

    it "renders the new template of even_suggestion" do 
      event = Event.create! valid_attributes
      get :new_event_suggestion, {:id => event.to_param}, valid_session
      expect(response).to render_template("event_suggestions/new")
    end
  end

  describe "GET new_event_template" do
    it "assigns a new event_template as @event_template" do
      event = Event.create! valid_attributes
      get :new_event_template, {:id => event.to_param}, valid_session
      expect(assigns(:event_template)).to have_attributes(:name => event.name, :description => event.description, :participant_count => event.participant_count, :rooms => event.rooms) 
      expect(response).to render_template("event_templates/new")
    end

    it "assigns the event id as @event_id" do 
      event = Event.create! valid_attributes
      get :new_event_template, {:id => event.to_param}, valid_session
      expect(assigns(:event_id)).to eq(event.id)
    end
  end

  describe "GET index_toggle_favorite" do
    it "redirects to events" do
      event = Event.create! valid_attributes
      get :index_toggle_favorite, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(events_url)
    end
    
    it "toggles the favorite event" do
      event = Event.create! valid_attributes
      
      get :index_toggle_favorite, {:id => event.to_param}, valid_session
      get :index, {}, valid_session
      expect(assigns(:favorites).include?(event)).to eq true

      get :index_toggle_favorite, {:id => event.to_param}, valid_session
      get :index, {}, valid_session
      expect(assigns(:favorites).include?(event)).to eq false
      
      get :index_toggle_favorite, {:id => event.to_param}, valid_session
      get :index, {}, valid_session
      expect(assigns(:favorites).include?(event)).to eq true
    end
  end

  describe "GET show_toggle_favorite" do
    it "redirects to event" do
      event = Event.create! valid_attributes
      get :show_toggle_favorite, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(event)
    end
    it "toggles the favorite event" do
      event = Event.create! valid_attributes
      get :show_toggle_favorite, {:id => event.to_param}, valid_session
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:favorite).empty?).to eq false

      get :show_toggle_favorite, {:id => event.to_param}, valid_session
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:favorite).empty?).to eq true

      get :show_toggle_favorite, {:id => event.to_param}, valid_session
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:favorite).empty?).to eq false
    end
  end

  describe "GET edit" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :edit, {:id => event.to_param}, valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, {:event => valid_attributes_for_request}, valid_session
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, {:event => valid_attributes_for_request}, valid_session
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it "redirects to the created event" do
        post :create, {:event => valid_attributes_for_request}, valid_session
        expect(response).to redirect_to(Event.last)
      end

      it "creates activity when an event is created" do
        post :create, {:event => valid_attributes_for_request}, valid_session
        event = Event.last
        create_event_activity = event.activities.first
        expected_changed_fields = ["name", "description", "participant_count", "starts_at",
        "ends_at", "is_private", "user_id"]
        expect(event.activities.count).to eq(1)
        expect(create_event_activity.action).to eq("create")
        expect(create_event_activity.controller).to eq("events")
        expect(create_event_activity.username).to eq(user.username)
      end
    end

    describe "with invalid dates" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, {:event => invalid_attributes_for_request}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, {:event => invalid_attributes_for_request}, valid_session
        expect(response).to render_template("new")
      end
    end

	  describe "with invalid participant count" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, {:event => invalid_participant_count_for_request}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, {:event => invalid_participant_count_for_request}, valid_session
        expect(response).to render_template("new")
      end
    end

    describe "and prior event_template" do
      before(:all) do 
        DatabaseCleaner.clean
        DatabaseCleaner.start
        FactoryGirl.create(:event_template)
      end   
      
      it "assigns @event_template_id with the id of the prior event_template" do
        post :create, {:event => valid_attributes_with_template_id_for_request}, valid_session
        expect(assigns(:event_template_id).to_i).to eq(valid_attributes_with_template_id_for_request[:event_template_id])
      end

      it "creates a new Event" do
        expect {
          post :create, {:event => valid_attributes_with_template_id_for_request}, valid_session
        }.to change(Event, :count).by(1)
      end

      describe "without tasks" do
        it "then no new tasks are created" do
          expect {
            post :create, {:event => valid_attributes_with_template_id_for_request}, valid_session
          }.to_not change(Task, :count)
        end

        it "then new event has no tasks" do
          post :create, {:event => valid_attributes_with_template_id_for_request}, valid_session
          expect(assigns(:event).tasks).to be_empty
        end 
      end

      describe "with tasks" do
        before(:all) do
          DatabaseCleaner.clean
          FactoryGirl.create(:event_template, :with_tasks)
        end

        it "then new tasks are created" do
          event_template = EventTemplate.find(valid_attributes_with_template_id_for_request[:event_template_id]) 
          expect {
            post :create, {:event => valid_attributes_with_template_id_for_request}, valid_session
          }.to change(Task, :count).by(event_template.tasks.size)
        end

        it "then events tasks have the same values as the event_templates tasks" do
          post :create, {:event => valid_attributes_with_template_id_for_request}, valid_session
          event_template = EventTemplate.find(valid_attributes_with_template_id_for_request[:event_template_id]) 
          ignored = ['id', 'updated_at', 'created_at', 'event_template_id', 'event_id']
          assigns(:event).tasks.each_with_index do |task, i|
            expect(task.attributes.except(*ignored)).to eql(event_template.tasks[i].attributes.except(*ignored))
          end
        end

        describe "that have attachments" do 
          before(:all) do
            DatabaseCleaner.clean
            FactoryGirl.create(:event_template, :with_tasks_that_have_attachments)
          end

          it "then new attachments are created" do
            event_template = EventTemplate.find(valid_attributes_with_template_id_for_request[:event_template_id]) 
            attachment_count = event_template.tasks.inject(0) { |result, task| result + task.attachments.length}
            expect {
              post :create, {:event => valid_attributes_with_template_id_for_request}, valid_session
            }.to change(Attachment, :count).by(attachment_count)
          end

          it "then the events tasks attachments have the same values as the event_templates tasks attachments" do
            post :create, {:event => valid_attributes_with_template_id_for_request}, valid_session
            event_template = EventTemplate.find(valid_attributes_with_template_id_for_request[:event_template_id]) 
            ignored = ['id', 'updated_at', 'created_at', 'task_id']
            assigns(:event).tasks.each_with_index do |task, i|
                task.attachments.each_with_index do |attachment, j| 
                expect(attachment.attributes.except(*ignored)).to eql(event_template.tasks[i].attachments[j].attributes.except(*ignored))
              end
            end
          end
        end 
      end

      it "assigns a newly created Event to @event if wrong parameters" do
        post :create, {:event => invalid_attributes}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end
    end
    after(:all) do 
      DatabaseCleaner.clean
    end
  end

  describe "POST approve" do
    it "creates activity when an event is approved" do
      event = Event.create! valid_attributes
      activities = event.activities
      expect{
      post :approve, {:id => event.to_param, :date => Date.today}
      }.to change(activities, :count).by(1)
      expect(activities.last.action).to eq("approve")
      expect(activities.last.controller).to eq("events")
      expect(activities.last.username).to eq(user.username)
    end
  end

  describe "POST decline" do
    it "creates activity when an event is declined" do
      event = Event.create! valid_attributes
      activities = event.activities
      expect{
      post :decline, {:id => event.to_param, :date => Date.today}
      }.to change(activities, :count).by(1)
      expect(activities.last.action).to eq("decline")
      expect(activities.last.controller).to eq("events")
      expect(activities.last.username).to eq(user.username)
    end
  end

  describe "POST create_even_suggestion" do
    before(:all) do 
      DatabaseCleaner.clean
      DatabaseCleaner.start 
      FactoryGirl.create :room1
      FactoryGirl.create :room2
      @event = FactoryGirl.create(:event)
    end 

    describe "with valid params" do
      it "creates a new Event" do
        expect {
          get :new_event_suggestion, {:id => @event.to_param}
          post :create_event_suggestion, {:event => valid_attributes_for_event_suggestion}, valid_session
        }.to change(Event, :count).by(1)
      end  

      it "creates a new Event with the status suggested" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => valid_attributes_for_event_suggestion}, valid_session
        expect(assigns(:event)[:status]).to eq('suggested')
      end

      it "creates a new Event with the name, description, participant_count, importance and privacy of the old event" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => valid_attributes_for_event_suggestion}, valid_session
        expect(assigns(:event)['name']).to eq(@event.name)
        expect(assigns(:event)['description']).to eq(@event.description)
        expect(assigns(:event)['participant_count']).to eq(@event.participant_count)
        expect(assigns(:event)['is_important']).to eq(@event.is_important)
        expect(assigns(:event)['is_private']).to eq(@event.is_private)
      end

      it "creates a new Event with the event_id pointing to the original Event" do 
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => valid_attributes_for_event_suggestion}, valid_session
        expect(assigns(:event).event_id).to eq(@event.id)
      end

      it "makes the original Event point to the newly created Event" do 
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => valid_attributes_for_event_suggestion}, valid_session
        @event.reload
        expect(@event.event_suggestion.id).to eq(assigns(:event).id)
      end

      it "assigns a newly created Event as @event" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => valid_attributes_for_event_suggestion}, valid_session
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it "redirects to the created event_suggestion" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => valid_attributes_for_event_suggestion}, valid_session
        expect(response).to redirect_to(Event.last)
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved Event as @event" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => invalid_attributes_for_event_suggestion}, valid_session
        expect(assigns(:event)).to be_a(Event)
      end

      it "original event_id is still assigned to @original_event_id" do 
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => invalid_attributes_for_event_suggestion}, valid_session
        expect(assigns(:original_event_id).to_i).to eq(@event.id)
      end  
     
      it "re-renders the 'new' template" do
        get :new_event_suggestion, {:id => @event.to_param}
        post :create_event_suggestion, {:event => invalid_attributes_for_event_suggestion}, valid_session        
        expect(response).to render_template("event_suggestions/new")
      end
    end

    after(:all) do 
      DatabaseCleaner.clean
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {name:'Michas GB 2',
        description:'Keine coole Sache',
        participant_count: 1,
        rooms: []
        }
      }

      it "updates the requested event" do
        event = Event.create! valid_attributes
        expect {
          put :update, {:id => event.to_param, :event => new_attributes}, valid_session
          event.reload
        }.to change(event, :updated_at)
      end

      it "assigns the requested event as @event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => valid_attributes_for_request}, valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "redirects to the event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => valid_attributes_for_request}, valid_session
        expect(response).to redirect_to(event)
      end

      describe "and the requested event has a rejected suggestion" do 
        it "sets the events status to pending" do 
          event = FactoryGirl.create(:declined_event, :user_id => user.id)
          FactoryGirl.create(:declined_event_suggestion, :user_id => user.id, :event_id => event.id)
          put :update, {:id => event.to_param, :event => valid_attributes_for_request}, valid_session
          event.reload
          expect(event.status).to eq('pending')
        end

        it "deletes the corresponding suggestion" do 
          event = FactoryGirl.create(:declined_event, :user_id => user.id)
          event_suggestion = FactoryGirl.create(:declined_event_suggestion, :user_id => user.id, :event_id => event.id)
          put :update, {:id => event.to_param, :event => valid_attributes_for_request}, valid_session
          expect(event_suggestion).not_to exist_in_database
        end
      end

      it "creates activity when an event is updated" do
        event = Event.create! valid_attributes
        activities = event.activities
        expected_changed_fields = ["name", "description", "participant_count"]
        expect{
        put :update, {:id => event.to_param, :event => new_attributes}, valid_session
        }.to change(activities, :count).by(1)
        expect(activities.last.action).to eq("update")
        expect(activities.last.username).to eq(user.username)
        expect(activities.last.changed_fields).to eq(expected_changed_fields)
      end
    end

    describe "with invalid params" do
      it "assigns the event as @event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "re-renders the 'edit' template" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "GET approve" do 
    it "approves the given event" do
      event = Event.create! valid_attributes
      @request.env['HTTP_REFERER'] = 'http://test.com/'
      get :approve, {:id => event.to_param}
      expect(assigns(:event).status).to eq('approved')
    end

    it "redirects to the last page" do
      event = Event.create! valid_attributes
      @request.env['HTTP_REFERER'] = 'http://test.com/'
      get :approve, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(:back)
    end
  end

  describe "GET approve_event_suggestion" do
    before(:all) do 
      DatabaseCleaner.clean
      DatabaseCleaner.start
      FactoryGirl.create(:room1)
      FactoryGirl.create(:room2)
      FactoryGirl.create(:event)
    end

    it "approves the given event suggestion" do 
      event = FactoryGirl.create(:declined_event, :user_id => user.id)
      event_suggestion = FactoryGirl.create(:event_suggestion, :event_id => event.id, :user_id => user.id)
      get :approve_event_suggestion, {:id => event_suggestion.to_param}
      expect(assigns(:event).status).to eq('pending')
    end

    it "removes the event suggestions reference to the original event" do 
      event = FactoryGirl.create(:declined_event, :user_id => user.id)
      event_suggestion = FactoryGirl.create(:event_suggestion, :event_id => event.id, :user_id => user.id)
      get :approve_event_suggestion, {:id => event_suggestion.to_param}
      event_suggestion.reload
      expect(event_suggestion.event_id).to be_nil
    end

    it "redirects to events_path" do
      event = FactoryGirl.create(:declined_event, :user_id => user.id)
      event_suggestion = FactoryGirl.create(:event_suggestion, :event_id => event.id, :user_id => user.id)
      get :approve_event_suggestion, {:id => event_suggestion.to_param}
      expect(response).to redirect_to(events_path)
    end
  end

  describe "GET decline_event_suggestion" do  # TO BE IMPLEMENTED !!!
    it "rejects the given event suggestion" do 
      event = FactoryGirl.create(:declined_event, :user_id => user.id)
      event_suggestion = FactoryGirl.create(:event_suggestion, :event_id => event.id, :user_id => user.id)
      get :decline_event_suggestion, {:id => event_suggestion.to_param}
      event_suggestion.reload
      expect(event_suggestion.status).to eq('rejected_suggestion')
    end

    it "redirects to events_path" do
      event = FactoryGirl.create(:declined_event, :user_id => user.id)
      event_suggestion = FactoryGirl.create(:event_suggestion, :event_id => event.id, :user_id => user.id)
      get :decline_event_suggestion, {:id => event_suggestion.to_param}
      expect(response).to redirect_to(events_path)
    end
  end

  describe "GET decline" do 
    it "declines the given event" do
      event = Event.create! valid_attributes
      @request.env['HTTP_REFERER'] = 'http://test.com/'
      get :decline, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
      expect(assigns(:event).status).to eq('declined')
    end

    it "redirects to the last page" do
      event = Event.create! valid_attributes
      @request.env['HTTP_REFERER'] = 'http://test.com/'
      get :decline, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
      expect(response).to redirect_to(:back)
    end
  end

  describe "DELETE destroy" do

    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, {:id => event.to_param}, valid_session
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      event = Event.create! valid_attributes
      delete :destroy, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(events_url)
    end

    it "destroys the event_suggestion, but not the original event" do 
      event = Event.create! valid_attributes
      event_suggestion = FactoryGirl.create :event_suggestion
      event = event_suggestion.event
      delete :destroy, {:id => event_suggestion.to_param}
      expect(event).to exist_in_database
    end
    
    it "if the original event is destroyed, the even_suggestion is also destroyed" do #DatabaseCleaner is not correctly configured
      event = Event.create! valid_attributes
      event_suggestion = FactoryGirl.create(:event_suggestion, :event_id => event.id)
      delete :destroy, {:id => event.to_param}
      expect(event_suggestion).not_to exist_in_database
    end
  end

  describe "If conflicting events" do 
    before(:all) do
      DatabaseCleaner.clean
      DatabaseCleaner.start
      FactoryGirl.create(:room1)
      FactoryGirl.create(:room2)
      FactoryGirl.create(:scheduledEvent)
    end

    after(:all) do 
      DatabaseCleaner.clean
    end 

    describe "do not exist" do 
      it "then no conflicting events are returned" do 
        patch :check_vacancy, event: not_conflicting_event, format: :json
        result = JSON.parse(response.body)
        expect(result).to include('status')
        expect(result['status']).to eq(true)
        expect(response.body).to eq(not_conflicting_result) 
      end
    end
    describe "do exist" do
      it "then conflicting events are returned" do 
        patch :check_vacancy, event: conflicting_event, format: :json
        result = JSON.parse(response.body)
        expect(result).to include('status')
        expect(result['status']).to eq(false)     
      end 

      it "then all conflicting events are returned" do 
        patch :check_vacancy, event: conflicting_event, format: :json
        result = JSON.parse(response.body)
        expect(result.length).to eq(2)
      end

      describe "and if the conflicting event" do 
        it "takes place on one day in one room, the correct error message gets returned" do 
          event = FactoryGirl.create :event_on_one_day_with_one_room
          start_time = I18n.l event.starts_at, format: :time_only
          end_time = I18n.l event.ends_at, format: :time_only
          conflicting_event = attributes_for(:event_on_one_day_with_multiple_rooms)
          patch :check_vacancy, event: conflicting_event, format: :json
          result = JSON.parse(response.body)
          expect(result[event.id.to_s]).to include('msg')
          expect(result[event.id.to_s]['msg']).to eq(I18n.t('event.alert.conflict_same_days_one_room', name: event.name, start_date: event.starts_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: event.rooms.pluck(:name).to_sentence))
        end

        it "takes place on multiple days in one room, the correct error message gets returned" do 
          event = FactoryGirl.create :event_on_multiple_days_with_one_room
          start_time = I18n.l event.starts_at, format: :time_only
          end_time = I18n.l event.ends_at, format: :time_only
          patch :check_vacancy, event: conflicting_event, format: :json
          result = JSON.parse(response.body)
          expect(result[event.id.to_s]).to include('msg')
          expect(result[event.id.to_s]['msg']).to eq(I18n.t('event.alert.conflict_different_days_one_room', name: event.name, start_date: event.starts_at.strftime("%d.%m.%Y"), end_date: event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: event.rooms.pluck(:name).to_sentence))
        end

        it "takes place on multiple days in mulitple rooms, the correct error message gets returned" do 
          event = FactoryGirl.create :event_on_multiple_days_with_multiple_rooms
          start_time = I18n.l event.starts_at, format: :time_only
          end_time = I18n.l event.ends_at, format: :time_only
          patch :check_vacancy, event: conflicting_event, format: :json
          result = JSON.parse(response.body)
          expect(result[event.id.to_s]).to include('msg')
          expect(result[event.id.to_s]['msg']).to eq(I18n.t('event.alert.conflict_different_days_multiple_rooms', name: event.name, start_date: event.starts_at.strftime("%d.%m.%Y"), end_date: event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: event.rooms.pluck(:name).to_sentence))
        end
        
        it "takes place on one day in multiple rooms, the correct error message gets returned" do 
          event = FactoryGirl.create :event_on_one_day_with_multiple_rooms
          start_time = I18n.l event.starts_at, format: :time_only
          end_time = I18n.l event.ends_at, format: :time_only
          conflicting_event = attributes_for(:event_on_one_day_with_multiple_rooms)
          patch :check_vacancy, event: conflicting_event, format: :json
          result = JSON.parse(response.body)
          expect(result[event.id.to_s]).to include('msg')
          expect(result[event.id.to_s]['msg']).to eq(I18n.t('event.alert.conflict_same_days_multiple_rooms', name: event.name, start_date: event.starts_at.strftime("%d.%m.%Y"), end_date: event.ends_at.strftime("%d.%m.%Y"), start_time: start_time, end_time: end_time, rooms: event.rooms.pluck(:name).to_sentence))
        end
      end
    end
  end
end
