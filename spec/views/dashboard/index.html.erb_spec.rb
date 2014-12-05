require 'rails_helper'

RSpec.describe "dashboard/index", :type => :view do
	let(:user) { create :user }
	before(:each) do
		login_as user, scope: :user
		visit '/'
	end

	describe 'My Tasks partial' do
		let!(:other_user) { create :user }
		let!(:event) { create :event, user_id: user.id }
		#let(:past_event) { create :event, name: 'Past Event', starts_at: Date.today - 2, ends_at: Date.today - 2, user_id: user.id}
		let!(:task) { create :assigned_task, event_id: event.id, user_id: user.id, status: 'accepted' }
		let!(:pending_task) { create :assigned_task, name: 'Pending Task', event_id: event.id, user_id: user.id }
		#let(:past_task) { create :assigned_task, name: "Past Task", event_id: past_event.id, user_id: user.id }
		let!(:other_task) { create :assigned_task, name: 'Other Task', event_id: event.id, user_id: other_user.id }

		before :each do
			Timecop.freeze(Date.today - 3) do 
				past_event = create :event, name: 'Past Event', user_id: user.id
				past_task = create :assigned_task, name: 'Past Task', event_id: past_event.id, user_id: user.id, status: 'accepted'
			end 
		end

		it 'should render partial' do
			page.should have_content t('dashboard.my_tasks')
		end

		it 'should only show current events' do
			page.should have_content event.name
			page.should_not have_content past_event.name
		end

		it 'should only show accepted tasks for current events' do
			page.should have_content task.name
			page.should_not have_content past_task.name
			page.should_not have_content pending_task.name
		end

		it 'should not show tasks for other users' do
			page.should_not have_content other_task.name
		end

	end

  	describe 'Events partial' do
    	#before(:each) do
    		#  6.times { |i| FactoryGirl.create(:upcoming_event, name: "Eventname"+i.to_s) }
    #end

    it 'renders the event overview' do
	    #page.should have_content 'Anstehende Events'
	    #page.should have_content 'Eventname0'
	    #page.should have_content 'Eventname1'
	    #page.should have_content 'Eventname2'
	    #page.should have_content 'Eventname3'
	    #page.should have_content 'Eventname4'
	    #page.should_not have_content 'Eventname5'
    end
  end
end