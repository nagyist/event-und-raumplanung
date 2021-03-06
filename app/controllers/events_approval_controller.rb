class EventsApprovalController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_user
  
  def index
    read_and_exec_params
    @open_events = Event.open.order(:starts_at, :user_id, :id).select{|event| can? :approve, event}
		@approved_events = Event.approved.where('starts_at BETWEEN ? AND ?', @date.beginning_of_day, @date.end_of_day).order(:starts_at, :user_id, :id).select{|event| can? :approve, event}
    @conflict_events = Event.approved.where('starts_at >= ?', Date.current)
  end

  private
    def read_and_exec_params
      begin
        if params[:date].is_a?(Hash)
          @date = (params[:date][:year]+ '-' + params[:date][:month] + '-' + params[:date][:day]).to_date
        else
          @date = params[:date].to_date
        end
      rescue
      end  
      @date = Date.current unless !@date.nil? && @date.acts_like_date?
    end
    def authorize_user
      authorize! :approve_any, Event
    end
end
