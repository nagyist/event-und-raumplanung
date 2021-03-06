# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

#
## Delete old records from database
delete_old_records = false
if delete_old_records
	Room.delete_all
	Equipment.delete_all
	Event.delete_all
	Task.delete_all
end

#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Rooms
room1 = Room.create(name: 'A-1.1', size: 28)
room2 = Room.create(name: 'A-1.2', size: 39)
room3 = Room.create(name: 'A-2.1', size: 30)
room4 = Room.create(name: 'A-2.2', size: 31)
room5 = Room.create(name: 'D-E.10', size: 20)
room6 = Room.create(name: 'D-E.9', size: 21)
room7 = Room.create(name: 'H-2.57', size: 40)
room8 = Room.create(name: 'H-2.58', size: 24)
room9 = Room.create(name: 'H-E.51', size: 44)
room10 = Room.create(name: 'H-E.52', size: 20)
room11 = Room.create(name: 'HS 1', size: 200)
room12 = Room.create(name: 'HS 2', size: 100)
room13 = Room.create(name: 'HS 3', size: 99)

## Create Users
user2 = User.find_by username: 'max.mustermann'
if user2.nil?
	user2 = User.create(email: 'Max.Mustermann.' + DateTime.now.to_s + '@example.com', username: 'max.mustermann', identity_url: 'http://example.com/Max.Mustermann.' + DateTime.now.to_s)
end
user3 = User.find_by username: 'erika.musterfrau'
if user3.nil?
	user3 = User.create(email: 'Erika.Musterfrau.' + DateTime.now.to_s + '@example.com', username: 'erika.musterfrau', identity_url: 'http://example.com/Erika.Musterfrau.' + DateTime.now.to_s)
end
user1 = User.all.first

event = Event.create({name: 'Klubtreffen',
					description: 'Klubtreffen des PR-Klubs',
					starts_at: Date.today + 1,
					ends_at: Date.today + 1,
					participant_count: 12,
					rooms: [room2],
					user_id: user1.id})

another_event = Event.create({name: 'Vorlesung',
					description: 'A description',
					starts_at: Date.today + 1,
					ends_at: Date.today + 1,
					participant_count: 80,
					rooms: [room2],
					user_id: user1.id})

task = Task.new({name: 'An accepted Task', 
			description: 'This is an accepted task.',
			event_id: event.id,
			identity_type: 'User',
			identity_id: 1,
			creator_id: user1.id,
			status: 'accepted'})
task.skip_sending_mails = true
task.save

task = Task.new({name: 'Another accepted Task', 
			description: 'This is a accepted task which is already done.',
			event_id: another_event.id,
			identity_type: 'User',
			identity_id: 1,
			creator_id: user1.id,
			status: 'accepted',
			done: true })
task.skip_sending_mails = true
task.save

task = Task.new({name: 'A pending Task', 
			description: 'This is a pending task.',
			event_id: event.id,
			identity_type: 'User',
			identity_id: 1,
			creator_id: user1.id,
			status: 'pending'})
task.skip_sending_mails = true
task.save

task = Task.new({name: 'A second pending Task', 
			description: 'This is another pending task.',
			event_id: another_event.id,
			identity_type: 'User',
			identity_id: 1,
			creator_id: user1.id,
			status: 'pending'})

task = Task.new({:name => 'A Task', :description => 'This is a task.', :status => "not_assigned", creator_id: user1.id})
task.skip_sending_mails = true
task.save

#
# Create Equipment
equipment1 = Equipment.create(name: 'Beamer HD 124794', description: 'Ein fest installierter Beamer mit HD', room_id: room1.id, category: 'Beamer')
equipment2 = Equipment.create(name: 'Whiteboard 23', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: room1.id, category: 'Whiteboard')
equipment3 = Equipment.create(name: 'Beamer HD 12474324', description: 'Ein fest installierter Beamer mit HD', room_id: room2.id, category: 'Beamer')
equipment4 = Equipment.create(name: 'Beamer HD 124734', description: 'Ein fest installierter Beamer mit HD', room_id: room3.id, category: 'Beamer')
equipment5 = Equipment.create(name: 'Beamer HD 12474234', description: 'Ein fest installierter Beamer mit HD', room_id: room4.id, category: 'Beamer')
equipment6 = Equipment.create(name: 'Beamer HD 12424424', description: 'Ein fest installierter Beamer mit HD', room_id: room5.id, category: 'Beamer')
equipment7 = Equipment.create(name: 'Beamer HD 1247912', description: 'Ein fest installierter Beamer mit HD', room_id: room6.id, category: 'Beamer')
equipment8 = Equipment.create(name: 'Whiteboard 234', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: room7.id, category: 'Whiteboard')

#
# create Comments
comment = Comments.create(user_id: 1, content: "Ich will MEHR PIZZA!!!", created_at: "2014-12-26 13:37:42", event_id: 1)
comment = Comments.create(user_id: 1, content: "Ich will NOCH MEHR PIZZA!!!", created_at: "2014-12-26 15:37:42", event_id: 1)

#
# Create Event
# watch out! some Events aren't created anymore, because of validation failures, but Event.create without an "!" doesn't throw an exception
event1 = Event.create(name: "Weihnachtsfeier", description: "Details zur Weihnachtsfeier 2015", participant_count: 10,  status: "In Bearbeitung", created_at: "2015-11-20 12:20:20", user_id: user2.id, rooms: [room1], is_private: false, is_important: true, starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01")
event2 = Event.create(name: "Sommerfest", description: "Details zur Sommerfest 2015", participant_count: 10,  status: "In Bearbeitung", created_at: "2015-11-20 12:20:20", user_id: user2.id, rooms: [room2], is_private: false, is_important: false, starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01")
event3 = Event.create(name: "Tribute von Panem", description: "Details zum Event Tribute von Panem 2015", participant_count: 10, created_at: "2015-11-20 12:20:20", user_id: user2.id, rooms: [room3], is_private: true, is_important: false, starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01")
event4 = Event.create(name: 'Mathe', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: user2.id, rooms: [room13], is_private: false, is_important: false, starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event5 = Event.create(name: 'PT', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: user2.id, rooms: [room12], is_private: false, is_important: true,  status: "declined", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event6 = Event.create(name: 'POIS', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: user2.id, rooms: [room7], is_private: false, is_important: true,  status: "approved", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event7 = Event.create(name: 'ISEC', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: user3.id, rooms: [room12], is_private: false, is_important: false,  status: "declined", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event8 = Event.create(name: 'HCI II', description: 'Vorlesung', participant_count: 40, created_at: DateTime.now, user_id: user3.id, rooms: [room13, room12], is_private: false, is_important: true,  status: "declined", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event9 = Event.create(name: 'HCI II', description: 'Vorlesung 1', starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 3), rooms: [room13])
event10 = Event.create(name: 'HCI II', description: 'Vorlesung 2', starts_at: DateTime.now.advance(days: 2), ends_at: DateTime.now.advance(days: 2, hours: 3), rooms: [room13])
event11 = Event.create(name: 'Connect Club Treffen', description: 'Clubtreffen', starts_at: DateTime.now.advance(days: 2), ends_at: DateTime.now.advance(days: 2, hours: 3), rooms: [room1])

#
# Create recurring events
schedule = IceCube::Schedule.from_hash({:start_time=>Time.now.change(hour: 11).advance(days: 1).to_s, :end_time=>Time.now.change(hour: 12, min: 30).advance(days: 1).to_s, :rrules=>[{:validations=>{:day=>[1, 4]}, :rule_type=>"IceCube::WeeklyRule", :interval=>1, :week_start=>0}], :rtimes=>[], :extimes=>[]})
event12 = Event.create!(name: 'Vorlesung PT', description: 'Vorlesung PT Montag/Donnerstag', participant_count: 20, user_id: user1.id, starts_at: schedule.start_time, ends_at: schedule.end_time, rooms: [room12, room2], is_important: true, schedule: schedule)

schedule = IceCube::Schedule.from_hash({:start_time=>Time.now.change(hour: 13, min: 30).advance(days: 1).to_s, :end_time=>Time.now.change(hour: 15).advance(days: 1).to_s, :rrules=>[{:validations=>{:day=>[1]}, :rule_type=>"IceCube::WeeklyRule", :interval=>1, :week_start=>0}], :rtimes=>[], :extimes=>[]})
event13 = Event.create!(name: 'Vorlesung POIS', description: 'Vorlesung 1 Montag', participant_count: 20, user_id: user1.id, starts_at: schedule.start_time, ends_at: schedule.end_time, rooms: [room7], schedule: schedule)

schedule = IceCube::Schedule.from_hash({:start_time=>Time.now.change(hour: 11).advance(days: 1).to_s, :end_time=>Time.now.change(hour: 12, min: 30).advance(days: 1).to_s, :rrules=>[{:validations=>{:day=>[3]}, :rule_type=>"IceCube::WeeklyRule", :interval=>1, :week_start=>0}], :rtimes=>[], :extimes=>[]})
event14 = Event.create(name: 'Vorlesung POIS', description: 'Vorlesung 2 Mittwoch', participant_count: 20, user_id: user1.id, starts_at: schedule.start_time, ends_at: schedule.end_time, rooms: [room1], schedule: schedule)

schedule = IceCube::Schedule.from_hash({:start_time=>Time.now.change(hour: 15, min: 15).advance(days: 1).to_s, :end_time=>Time.now.change(hour: 16, min: 45).advance(days: 1).to_s, :rrules=>[{:validations=>{:day=>[3]}, :rule_type=>"IceCube::WeeklyRule", :interval=>1, :week_start=>0}], :rtimes=>[], :extimes=>[]})
event15 = Event.create(name: 'Vorlesung ISEC', description: 'Vorlesung 1 Mittwoch', participant_count: 20, user_id: user1.id, starts_at: schedule.start_time, ends_at: schedule.end_time, rooms: [room12], is_important: true, schedule: schedule)

schedule = IceCube::Schedule.from_hash({:start_time=>Time.now.change(hour: 9, min: 15).advance(days: 1).to_s, :end_time=>Time.now.change(hour: 10, min: 45).advance(days: 1).to_s, :rrules=>[{:validations=>{:day=>[4]}, :rule_type=>"IceCube::WeeklyRule", :interval=>1, :week_start=>0}], :rtimes=>[], :extimes=>[]})
event16 = Event.create(name: 'Vorlesung ISEC', description: 'Vorlesung 2 Donnerstag', participant_count: 20, user_id: user2.id, status: "approved", starts_at: schedule.start_time, ends_at: schedule.end_time, rooms: [room12], schedule: schedule)

schedule = IceCube::Schedule.from_hash({:start_time=>Time.now.change(hour: 11, min: 00).advance(days: 1).to_s, :end_time=>Time.now.change(hour: 12, min: 30).advance(days: 1).to_s, :rrules=>[{:validations=>{:day=>[5]}, :rule_type=>"IceCube::WeeklyRule", :interval=>1, :week_start=>0}], :rtimes=>[], :extimes=>[]})
event17 = Event.create(name: 'Vorlesung ISEC', description: 'Vorlesung 3 Freitag', participant_count: 20, user_id: user2.id, starts_at: schedule.start_time, ends_at: schedule.end_time, rooms: [room12], is_important: true, schedule: schedule)

schedule = IceCube::Schedule.from_hash({:start_time=>Time.now.change(hour: 11, min: 00).advance(days: 1).to_s, :end_time=>Time.now.change(hour: 12, min: 30).advance(days: 1).to_s, :rrules=>[{:validations=>{:day=>[2, 4]}, :rule_type=>"IceCube::WeeklyRule", :interval=>1, :week_start=>0}], :rtimes=>[], :extimes=>[]})
event18 = Event.create(name: 'Vorlesung Mathe', description: 'Vorlesung 1 Dienstag/Donnerstag', participant_count: 20, user_id: user2.id, starts_at: schedule.start_time, ends_at: schedule.end_time, rooms: [room13], schedule: schedule)
