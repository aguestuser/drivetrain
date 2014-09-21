class ConflictsController < ApplicationController
  include Paths, Sortable

  before_action :load_conflict, only: [ :edit, :update, :show, :destroy ]
  before_action :load_caller # callbacks: load_rider (if applicable)
  before_action :load_base_path
  before_action :load_form_args, only: [ :edit, :update ]
  before_action :load_conflicts, only: [ :index ]
  # before_action :load_rider, only: [ :index, :destroy ]

  def new
    @conflict = Conflict.new(start: params[:start], :end => params[:end])
    load_form_args
  end

  def create
    @conflict = Conflict.new(conflict_params.except(:base_path))
    load_form_args
    if @conflict.save
      flash[:success] = "Created conflict for #{@conflict.rider.contact.name}"
      redirect_to @base_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @conflict.update(conflict_params.except(:base_path))
    if @conflict.save
      flash[:success] = "Edited conflict for #{@conflict.rider.contact.name}"
      redirect_to @base_path
    else
      render 'edit'
    end
  end

  def show
  end

  def index
    @conflict_table = Table.new(:conflict, @conflicts, @caller, @base_path)
  end

  def destroy
    @conflict.destroy
    flash[:success] = "Conflict deleted"
    path = @base_path ? @base_path : @conflict_paths[:index]
    redirect_to path
  end

  def build_batch_preview
    render 'build_batch_preview'
    # view has dropdown for rider & start_t, gets #preview_batch
  end

  def preview_batch
    @rider = Rider.find(params[:rider_id])
    
    @this_week_start = params[:week_start].to_datetime
    @next_week_start = @this_week_start + 1.week
    this_week_end = @this_week_start + 1.week

    old_conflicts = @rider.conflicts_between(@this_week_start, this_week_end)
    @conflicts = Conflict.clone(old_conflicts).each { |c| c.increment_by(1.week) }

    @new_batch_query = { rider_id: @rider.id, week_start: @next_week_start }.to_query
    render 'preview_batch'
    # view posts to #batch_create (w/ conflicts params) or gets #batch_new (w/ rider & start_t params)
    # is the same as email view
  end

  def batch_new
    @rider = Rider.find(params[:rider_id])
    @start_t = params[:start_t] || now_unless_test.beginning_of_week
  end

  def do_batch_new
    conflicts = parse_batch_new params[:conflicts]
    batch_create conflicts
  end

  def batch_create
    conflicts = Conflict.batch_from_params(params[:conflicts])
    @errors = Conflict.batch_create_ conflicts
    if @errors.empty? || conflicts.empty?
      flash[:success] = "#{conflicts.length} conflicts successfully created"
      redirect_to @base_path
    else
      flash[:error] = "Error creating conflicts."

      rider_id = conflicts.first[:rider_id]
      week_start = conflicts.first.start.beginning_of_week 
      query = { rider_id: rider_id, week_start: week_start, base_path: @base_path }.to_query
      
      redirect_to "/conflicts/preview_batch?#{query}"
    end
  end

  private

    def load_conflict
      @conflict = Conflict.find(params[:id])
    end

    def load_caller
      if params.include? :rider_id
        @caller = :rider
        load_rider
      end
      load_root_key
    end

    def load_root_key
      @root_key = :conflict
      load_base_path
      # raise @base_path.inspect
    end

    def load_rider
      @rider = Rider.find(params[:rider_id])
    end

    def load_form_args
      case @caller
      when :rider
        @form_args = [ @rider, @conflict ]
      when nil
        @form_args = @conflict
      end
    end

    def load_conflicts
      case @caller
      when :rider
        base = Conflict.where("conflicts.rider_id = ?", params[:rider_id])       
      when nil
        base = Conflict.all
      end
      @conflicts = base
        .joins( rider: :contact)
        .page(params[:page])
        .order(sort_column + " " + sort_direction)
    end

    def conflict_params
      params.require(:conflict).permit(:id, :start, :end, :period, :rider_id, :base_path, :start)
    end
end
