class EventsController < ApplicationController

  def index
    @future = Event.future.page(params[:future_page]).order('ends_at ASC')
    @old = Event.page(params[:old_page]).order('ends_at DESC')

    if params[:start] and params[:end]
      @start_time = Time.at(params[:start].to_i / 1000.0)
      @end_time = Time.at(params[:end].to_i / 1000.0)
      
      @old = @old.where(ends_at: @start_time..@end_time)
    else
      @old = @old.past
    end

    @old = @old.name_like(params[:query]) if params[:query]

    respond_to do |format|
        format.html { render :index }
        format.json { render json: @future | @old }
    end
  end

  def typeahead
    render json: Event.name_like(params[:query])
  end

  def locations
    today_events = Event.future.where('coordinates IS NOT NULL')

    event_data = today_events.map{ |event| {:uid => event.uid,
                                  :name => event.name,
                                  :coordinates => event.coordinates,
                                  :isToday => event.current? } }
                                  
    render json: event_data
  end

  def all_events
    
    # warning, date() in sqlite returns a string, but in postgres it returns a Date
    events = Event.where("date(ends_at) < ?", Date.today)
                  .group("date(ends_at)")
                  .order('date(ends_at) DESC')
                  .distinct.count(:uid)
    
    events = events.map do |date, count|      
      {c:[
        {v: to_js_date(date)},
        {v: count}
      ]}
    end

    datatable = {
      "cols": [
        {'id': '', 'label': 'day', 'type': 'date'},
        {'id': '', 'label': 'events', 'type': 'number'}
      ],
      "rows": events
    }

    respond_to do |format|
      format.json { render json: datatable }
    end
  end

end
