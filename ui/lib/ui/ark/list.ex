defmodule Ark.List do
    defstruct auto_id: 1, entries: %{}
  
    def new(entries \\ []) do
      Enum.reduce(
        entries,
        %Ark.List{},
        &add_entry(&2, &1)
      )
    end
  
    def size(ark_list) do
      Map.size(ark_list.entries)
    end
  
    def add_entry(ark_list, entry) do
      entry = Map.put(entry, :id, ark_list.auto_id)
      new_entries = Map.put(ark_list.entries, ark_list.auto_id, entry)
  
      %Ark.List{ark_list | entries: new_entries, auto_id: ark_list.auto_id + 1}
    end
  
    def entries(ark_list, date) do
      ark_list.entries
      |> Stream.filter(fn {_, entry} -> entry.date == date end)
      |> Enum.map(fn {_, entry} -> entry end)
    end
  
    def update_entry(ark_list, %{} = new_entry) do
      update_entry(ark_list, new_entry.id, fn _ -> new_entry end)
    end
  
    def update_entry(ark_list, entry_id, updater_fun) do
      case Map.fetch(ark_list.entries, entry_id) do
        :error ->
          ark_list
  
        {:ok, old_entry} ->
          new_entry = updater_fun.(old_entry)
          new_entries = Map.put(ark_list.entries, new_entry.id, new_entry)
          %Ark.List{ark_list | entries: new_entries}
      end
    end
  
    def delete_entry(ark_list, entry_id) do
      %Ark.List{ark_list | entries: Map.delete(ark_list.entries, entry_id)}
    end
  end