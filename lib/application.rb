require 'sinatra/base'
require 'haml'

require 'todo/db'
require 'todo/task'

module Todo
  class Application < Sinatra::Base

    use Rack::MethodOverride

    set :haml, escape_html: true

    helpers do
      def error_class(task, name)
        task.errors.has_key?(name) ? 'has-error' : ''
      end

      def options_for_task_status(task)
        Task::STATUS.map { |key, value|
          selected = (value == task.status) ? 'selected' : ''
          %(<option value="#{value}"#{selected}>#{key}</option>)
        }.join
      end
    end

    configure do
      DB.prepare
    end

    configure :development do
      require 'sinatra/reloader'
      register Sinatra::Reloader
    end

    get '/' do
      redirect '/tasks'
    end

    get '/tasks' do
      @tasks = Task.order('created_at DESC')
      if @status = params[:status]
        case @status
        when 'not_yet'
          @tasks = @tasks.status_is_not_yet
        when 'done'
          @tasks = @tasks.status_is_done
        when 'pending'
          @tasks = @tasks.status_is_pending
        else
          @status = nil
        end
      end

      haml :index
    end

    get '/tasks/new' do
      @task = Task.new

      haml :new
    end

    get '/tasks/:id/edit' do
      begin
        @task = Task.find(params[:id])

        haml :edit
      rescue ActiveRecord::RecordNotFound
        error 404
      end
    end

    post '/tasks' do
      begin
        Task.create!(name: params[:name], content: params[:content])

        redirect '/'
      rescue ActiveRecord::RecordInvalid => e
        @task = e.record

        haml :new
      end
    end

    put '/tasks/:id' do
      begin
        task = Task.find(params[:id])
        task.update_attributes!(
          name: params[:name],
          content: params[:content],
          status: params[:status]
        )

        redirect '/'
      rescue ActiveRecord::RecordInvalid => e
        @task = e.record

        haml :edit
      rescue ActiveRecord::RecordNotFound
        error 404
      end
    end

    delete '/tasks/:id' do
      begin
        task = Task.find(params[:id])
        task.destroy

        redirect '/'
      rescue ActiveRecord::RecordNotFound
        error 404
      end
    end

    not_found do
      haml :not_found
    end
  end
end
