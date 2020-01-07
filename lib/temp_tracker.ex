defmodule WorldTemp.TempTracker do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> nil end, name: __MODULE__)
  end

  def get_coldest_city do
    Agent.get(__MODULE__, fn {city, country, temp} ->
      "The coldest city on earth is currently #{city}, #{country} at a chily #{
        to_fahrenheit(temp)
      } degrees fahrenheit!"
    end)
  end

  @spec update_coldest_city(:error | {any, any, any}) :: nil | :ok
  def update_coldest_city(:error), do: nil

  def update_coldest_city({_, _, new_temp} = new_data) do
    Agent.update(__MODULE__, fn
      {_, _, orig_temp} = orig_data ->
        if new_temp < orig_temp, do: new_data, else: orig_data

      nil ->
        new_data
    end)
  end

  defp to_fahrenheit(temp), do: kelvin_to_celsius(temp) |> celsius_to_fahrenheit()
  defp kelvin_to_celsius(kelvin), do: kelvin - 273.15
  defp celsius_to_fahrenheit(celsius), do: celsius * 1.8 + 32
end
