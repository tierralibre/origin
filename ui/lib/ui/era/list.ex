defmodule Era.List do
    defstruct auto_id: 1, entries: %{}
  
    def new(entries \\ []) do
      Enum.reduce(
        entries,
        %Era.List{},
        &add_entry(&2, &1)
      )
    end
  
    def size(era_list) do
      Map.size(era_list.entries)
    end
  
    def add_entry(era_list, entry) do
      entry = Map.put(entry, :id, era_list.auto_id)
      new_entries = Map.put(era_list.entries, era_list.auto_id, entry)
  
      %Era.List{era_list | entries: new_entries, auto_id: era_list.auto_id + 1}
    end

    def entries(era_list) do
      era_list.entries
      |> Enum.map(fn {_, entry} -> entry end)
    end
  
    def entries(era_list, date) do
      era_list.entries
      |> Stream.filter(fn {_, entry} -> entry.date == date end)
      |> Enum.map(fn {_, entry} -> entry end)
    end
  
    def update_entry(era_list, %{} = new_entry) do
      update_entry(era_list, new_entry.id, fn _ -> new_entry end)
    end
  
    def update_entry(era_list, entry_id, updater_fun) do
      case Map.fetch(era_list.entries, entry_id) do
        :error ->
          era_list
  
        {:ok, old_entry} ->
          new_entry = updater_fun.(old_entry)
          new_entries = Map.put(era_list.entries, new_entry.id, new_entry)
          %Era.List{era_list | entries: new_entries}
      end
    end
  
    def delete_entry(era_list, entry_id) do
      %Era.List{era_list | entries: Map.delete(era_list.entries, entry_id)}
    end
  end