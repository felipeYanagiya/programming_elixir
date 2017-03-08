defmodule Sequence.Server do
  use GenServer

  def whatever([]) do
    exit(:boom)
  end
  
  def whatever(stack) do
    List.pop_at(stack, 0)
  end

  def push_item(item, stack) do
    List.insert_at(stack, 0, item)
  end

  def handle_cast({:push, item}, stack) do    
    {:noreply, push_item(item, stack)}
  end

  def handle_call(:pop, _from, stack) do
    { new_stack, item } = whatever(stack)
    {:reply, new_stack, item}
  end
end
