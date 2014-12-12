class EventsController < ApplicationController
  skip_filter :verify_authenticity_token, :check_vacancy
 # skip_filter :authenticate_user, :check_vacancy
  skip_before_filter :authenticate_user!
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :approve, :decline, :approve_or_decline, :new_event_template, :new_event_suggestion]
  before_action :set_return_url, only: [:show, :new, :edit]

  load_and_authorize_resource

  skip_load_and_authorize_resource :only =>[:index, :show, :new, :create, :new_event_template, :reset_filterrific, :check_vacancy, :new_event_suggestion, :decline, :approve, :approve_or_decline]
  after_filter :flash_to_headers, :only => :check_vacancy

  def current_user_id
    current_user.id
  end

   def flash_to_headers
    if request.xhr?
      #avoiding XSS injections via flash
      flash_json = Hash[flash.map{|k,v| [k,ERB::Util.h(v)] }].to_json
      response.headers['X-Flash-Messages'] = flash_json
      flash.discard
    end
  end

  # GET /events/1/new_event_template
  def new_event_template
    @event_template = EventTemplate.new
    @event_template.name = @event.name
    @event_template.description = @event.description
    @event_template.participant_count = @event.participant_count
    @event_template.rooms = @event.rooms
    render "event_templates/new"
  end

  def new_event_suggestion
    @event_suggestion = EventSuggestion.new
    @event_suggestion.starts_at = @event.starts_at
    @event_suggestion.ends_at = @event.ends_at
    @event_suggestion.rooms = @event.rooms
    render "event_suggestions/new"
  end

  # GET /events
  # GET /events.json
  def index


     @filterrific = Filterrific.new(
      Event,
      params[:filterrific] || session[:filterrific_events])
      @filterrific.select_options =   {
        sorted_by: Event.options_for_sorted_by
      }
      @filterrific.own = if @filterrific.own == 1
          current_user_id
        else
          nil
        end
      @filterrific.room_ids = Room.all.map(&:id) if @filterrific.room_ids && @filterrific.room_ids.size <=1
      @events = Event.filterrific_find(@filterrific).page(params[:page])

      session[:filterrific_events] = @filterrific.to_hash


    respond_to do |format|
      format.html
      format.js
    end
  end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_events] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end

  def approve
<<<<<<< HEAD
    @event.update(status: 'approved')
=======
    puts 'message: ' + params[:message]
    @event.update(approved: true)
    if params[:message] == nil or params[:message].strip.empty?
      UserMailer.event_accepted_email_without_message(User.find(@event.user_id), @event).deliver;
    else
      UserMailer.event_accepted_email_with_message(User.find(@event.user_id), @event, params[:message]).deliver;
    end
>>>>>>> 322a042596223ae5870eadc628e6d56fe1a15841
    redirect_to events_approval_path(date: params[:date]) #params are not checked as date is no attribute of event and passed on as a html parameter
  end

  def decline
<<<<<<< HEAD
    @event.update(status: 'declined')
=======
    @event.update(approved: false)
    if params[:message] == nil or params[:message].strip.empty?
      UserMailer.event_declined_email_without_message(User.find(@event.user_id), @event).deliver;
    else
      UserMailer.event_declined_email_with_message(User.find(@event.user_id), @event, params[:message]).deliver;
    end

>>>>>>> 322a042596223ae5870eadc628e6d56fe1a15841
    redirect_to events_approval_path(date: params[:date]) #params are not checked as date is no attribute of event and passed on as a html parameter
  end

  def approve_or_decline
    if(params[:commit] == 'Approve')
      self.approve
    else
      self.decline
    end
  end

  def check_vacancy
    checked_params = event_params

    @event = Event.new(event_params)
    @event.user_id = current_user_id

    conflicting_events = @event.checkVacancy event_params[:room_ids]

    respond_to do |format|
      if conflicting_events.empty?
        flash[:notice] = "Vacant"
        format.json { render :json => {status: true}}
      else
        flash[:warning] = "Not available"

        msg = Hash[conflicting_events.map { |event|
          eventname = @event.id
          eventname = event.name if (event.user_id == current_user_id || !event.is_private)
          [event.id, {"event_name" => eventname,  "starts_at" => event.starts_at, "ends_at" => event.ends_at, "rooms" => event.rooms.pluck(:name)}]}]
        msg[:status]= false
        format.json { render :json => msg}
      end
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @user = User.find(@event.user_id).identity_url
    logger.info @event.rooms.inspect
    @tasks = @event.tasks.rank(:task_order)
  end

  # GET /events/new
  def new
    @event = Event.new
    time = Time.new.getlocal
    time -= time.sec
    time += time.min % 15
    @event.starts_at = time
    @event.ends_at = (time+(60*60))
  end

  # GET /events/1/edit
  def edit
    #authorize! :edit, @event
  end

  def sugguest
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user_id
    logger.info @event.inspect

    respond_to do |format|
      if @event.save
        conflicting_events = @event.checkVacancy event_params[:room_ids]
        if conflicting_events.size > 1 ## this event is also in the returned list
          format.html { redirect_to @event, alert: t('alert.conflict_detected', :model => Event.model_name.human)  }
        end
        format.html { redirect_to @event, notice: t('notices.successful_create', :model => Event.model_name.human) }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
      respond_to do |format|
      if @event.update(event_params)
        conflicting_events = @event.checkVacancy event_params[:room_ids]
        logger.info "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        logger.info conflicting_events.inspect
        if conflicting_events.size > 1 ## this event is also in the returned list
          format.html { redirect_to @event, alert: t('alert.conflict_detected', :model => Event.model_name.human)  }
        end
        format.html { redirect_to @event, notice: t('notices.successful_update', :model => Event.model_name.human) }
       # format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
       # format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: t('notices.successful_destroy', :model => Event.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
<<<<<<< HEAD
      params.require(:event).permit(:event_id, :name, :description, :participant_count, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :is_private, :is_important, :show_only_my_events, :room_ids => [])
=======

      params.require(:event).permit(:event_id, :name, :description, :participant_count, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :is_private, :show_only_my_events, :message, :commit,:room_ids => [])
>>>>>>> 322a042596223ae5870eadc628e6d56fe1a15841
    end

    def set_return_url
      @return_url = tasks_path
      @return_url = root_path if request.referrer && URI(request.referer).path == root_path
    end

end
