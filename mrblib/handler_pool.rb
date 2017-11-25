##
# Class: handler request pool class
#
# Handler each request in queue and complete
# each request in separate thread
# You can set number of threads for pool
#
class HandlerPool
  
  ##
  # Constuctor:
  # 
  # Initialize HandlerPool instance
  #
  # Params:
  # - size {Int} size of thread pool workers
  #
  # Response:
  # - pool {HandlerPool}
  #
  def initialize(size = 10)
    @size  = size
    @queue = Queue.new
    @pool  = Array.new(@size) do |i|
      Thread.new(@queue) do |queue|
        begin
          catch(:exit) do
            loop do
              job, args = queue.shift
              job.call(*args)
            end
          end
        rescue => error
          raise error
        end
      end
    end
  end

  ##
  # Schedule a new worker for @pool
  #
  # Params: 
  # - args  {Array} Array of arguments for worker
  # - block {Proc}  Worker Proc
  #
  # Response:
  # - None
  #
  def schedule(*args, &block)
    @queue.push([block, args])
  end

  ##
  # Shutdown method for HandlerPool instance
  # join all threads
  #
  # Params:
  # - None
  #
  # Response:
  # - None
  #
  def shutdown
    @size.times do
      schedule { throw :exit }
    end

    @pool.map(&:join)
  end
end