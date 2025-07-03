Mix.install([
  {:phoenix_playground, "~> 0.1.6"},
  {:plox, path: "."}
])

defmodule DemoLive do
  @moduledoc """
  Example graph rendered within a Phoenix Playground application.
  """
  use Phoenix.LiveView

  import Plox

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, mount_simple_line_graph(socket)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.simple_line_graph simple_graph={@simple_graph} clicked_point={@clicked_point} />
    """
  end

  @impl Phoenix.LiveView
  def handle_event(
        "toggle_tooltip",
        %{"id" => point_id, "dataset_id" => dataset_id, "x_pixel" => x_pixel, "y_pixel" => y_pixel},
        socket
      ) do
    {:noreply,
     assign(socket,
       clicked_point: %{
         id: point_id,
         dataset_id: String.to_existing_atom(dataset_id),
         x_pixel: x_pixel,
         y_pixel: y_pixel
       }
     )}
  end

  def handle_event("toggle_tooltip", _params, socket), do: {:noreply, assign(socket, clicked_point: nil)}

  defp mount_simple_line_graph(socket) do
    simple_data = [
      %{date: ~D[2023-08-01], value: 45.0},
      %{date: ~D[2023-08-02], value: 40.0},
      %{date: ~D[2023-08-03], value: 35.0},
      %{date: ~D[2023-08-04], value: 60.0},
      %{date: ~D[2023-08-04], value: 10.0},
      %{date: ~D[2023-08-05], value: 15.0},
      %{date: ~D[2023-08-06], value: 25.0},
      %{date: ~D[2023-08-07], value: 20.0},
      %{date: ~D[2023-08-08], value: 10.0}
    ]

    date_scale = date_scale(Date.range(~D[2023-08-01], ~D[2023-08-08]))
    number_scale = number_scale(0.0, 80.0)

    dataset =
      dataset(simple_data,
        x: {date_scale, & &1.date},
        y: {number_scale, & &1.value}
      )

    assign(socket,
      simple_graph:
        to_graph(
          scales: [date_scale: date_scale, number_scale: number_scale],
          datasets: [dataset: dataset]
        ),
      clicked_point: nil
    )
  end

  defp simple_line_graph(assigns) do
    ~H"""
    <h2>Simple line graph with legend and tooltips</h2>

    <.graph :let={graph} id="simple_graph" for={@simple_graph} width="800" height="250">
      <:legend>
        <.legend_item color="orange" label="data" />
        <.legend_item color="green" label="more data" />
      </:legend>

      <:tooltips :let={graph}>
        <.tooltip
          :let={%{value: value, date: date}}
          :if={!is_nil(@clicked_point)}
          dataset={graph[@clicked_point.dataset_id]}
          point_id={@clicked_point.id}
          x_pixel={@clicked_point.x_pixel}
          y_pixel={@clicked_point.y_pixel}
          phx-click-away="toggle_tooltip"
        >
          <p>date: {date}</p>
          <p>value: {value}</p>
        </.tooltip>
      </:tooltips>

      <.x_axis :let={date} scale={graph[:date_scale]}>
        {Calendar.strftime(date, "%-m/%-d")}
      </.x_axis>

      <.y_axis :let={value} scale={graph[:number_scale]} ticks={5}>
        {value}
      </.y_axis>

      <.line_plot dataset={graph[:dataset]} />

      <.points_plot dataset={graph[:dataset]} phx-click="toggle_tooltip" />

      <.marker at={~D[2023-08-03]} scale={graph[:date_scale]}>
        Important date!
      </.marker>
    </.graph>
    """
  end
end

PhoenixPlayground.start(live: DemoLive)
