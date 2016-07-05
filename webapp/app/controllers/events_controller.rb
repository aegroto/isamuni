require 'date'

class EventsController < ApplicationController

def index
	three_weeks = Time.now + (3*7*24*60*60) 
    @future = Event.where("starts_at >= ?", three_weeks).limit(100).order('starts_at desc')
    @upcoming = Event.where(:starts_at => Time.zone.now.beginning_of_day..three_weeks).limit(100).order('starts_at desc')
    @old = Event.where("starts_at < ?", Time.zone.now.beginning_of_day).limit(100).order('starts_at desc')
  end

end

