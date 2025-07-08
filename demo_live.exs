Mix.install([
  {:phoenix_playground, "~> 0.1.7"},
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
    {:ok, socket |> mount_simple_line_graph() |> mount_logo_graph()}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.simple_line_graph {@graph} />

    <hr />

    <.logo_graph {@logo_graph} />
    """
  end

  defp mount_simple_line_graph(socket) do
    data =
      [
        %{date: ~D[2023-08-01], value: 35.0, intensity: 10, temperature: :cold},
        %{date: ~D[2023-08-02], value: 60.0, intensity: 20, temperature: :cold},
        %{date: ~D[2023-08-03], value: 65.0, intensity: 25, temperature: :normal},
        %{date: ~D[2023-08-04], value: 10.0, intensity: 45, temperature: :warm},
        %{date: ~D[2023-08-05], value: 50.0, intensity: 15, temperature: :warm}
      ]

    dimensions = Plox.Dimensions.new(670, 250)

    x_axis =
      Plox.XAxis.new(Plox.DateScale.new(Date.range(~D[2023-08-01], ~D[2023-08-05])), dimensions)

    y_axis = Plox.YAxis.new(Plox.NumberScale.new(0.0, 80.0), dimensions)
    radius_axis = Plox.LinearAxis.new(Plox.NumberScale.new(10, 45), min: 4, max: 10)

    color_axis =
      Plox.ColorAxis.new(Plox.FixedColorsScale.new(%{cold: "#1E88E5", normal: "#43A047", warm: "#FFC107"}))

    dataset =
      Plox.Dataset.new(data,
        x: {x_axis, & &1.date},
        y: {y_axis, & &1.value},
        radius: {radius_axis, & &1.intensity},
        color: {color_axis, & &1.temperature}
      )

    assign(socket,
      graph: %{
        x_axis: x_axis,
        y_axis: y_axis,
        dataset: dataset,
        dimensions: dimensions
      }
    )
  end

  defp simple_line_graph(assigns) do
    ~H"""
    <h2>Example graph</h2>

    <.graph dimensions={@dimensions}>
      <.x_axis_labels :let={date} axis={@x_axis}>
        {Calendar.strftime(date, "%-m/%-d")}
      </.x_axis_labels>

      <%!-- this wraps text... why does it take in `axis`?? if we want to follow the SVG, we need to pass in `x` --%>
      <.x_axis_label axis={@x_axis} value={~D[2023-08-02]} position={:top} color="red">
        {"Important Day"}
      </.x_axis_label>

      <.x_axis_grid_lines axis={@x_axis} stroke="#D3D3D3" />

      <.y_axis_labels :let={value} axis={@y_axis} ticks={5}>
        {value}
      </.y_axis_labels>

      <.y_axis_grid_lines axis={@y_axis} ticks={5} stroke="#D3D3D3" />

      <%!-- <.polyline dataset={@dataset} stroke="orange" stroke-width={2} /> --%>
      <.polyline points={Enum.zip(@dataset[:x], @dataset[:y])} stroke="orange" stroke-width={2} />

      <%!-- Access behavior with axes --%>
      <%!-- <.polyline points={{@dataset[:x], @dataset[:y]}} class="stroke-orange-500 dark:stroke-orange-400 stroke-2" /> --%>
      <%!-- constant y = 40 --%>
      <%!-- <.polyline points={{@dataset[:x], @dataset[:y][40]}} class="stroke-orange-500 dark:stroke-orange-400 stroke-2" /> --%>
      <%!-- <.circles dataset={@dataset} cx={:x} cy={:y} fill={:color} r={:radius} /> --%>
      <%!-- use the Access behavior --%>
      <.circle
        cx={@dataset[:x]}
        cy={@dataset[:y]}
        stroke={@dataset[:color]}
        fill="none"
        stroke-width="2px"
        r={@dataset[:radius]}
      />

      <%!-- pass in constant y-axis and color value --%>
      <.circle cx={@dataset[:x]} cy={@dataset[:y][40]} fill="red" r={@dataset[:radius]} />
    </.graph>
    """
  end

  defp mount_logo_graph(socket) do
    dimensions = Plox.Dimensions.new(440, 250)
    x_axis = Plox.XAxis.new(Plox.NumberScale.new(0.0, 10.0), dimensions)
    y_axis = Plox.YAxis.new(Plox.NumberScale.new(0.0, 6.0), dimensions)

    # Letter "P"
    p_data = [
      %{x: 1, y: 5},
      %{x: 2.5, y: 4},
      %{x: 1, y: 3},
      %{x: 1, y: 1}
    ]

    p_dataset =
      Plox.Dataset.new(p_data,
        x: {x_axis, & &1.x},
        y: {y_axis, & &1.y}
      )

    # Letter "L"
    l_data = [
      %{x: 3.5, y: 4.5},
      %{x: 3.5, y: 1}
    ]

    l_dataset =
      Plox.Dataset.new(l_data,
        x: {x_axis, & &1.x},
        y: {y_axis, & &1.y}
      )

    # Letter "O"
    o_data = [
      %{x: 4.5, y: 2},
      %{x: 5.5, y: 3},
      %{x: 6.5, y: 2},
      %{x: 5.5, y: 1},
      %{x: 4.5, y: 2}
    ]

    o_dataset =
      Plox.Dataset.new(o_data,
        x: {x_axis, & &1.x},
        y: {y_axis, & &1.y}
      )

    # Letter "X"
    x1_data = [
      %{x: 7, y: 3},
      %{x: 9, y: 1}
    ]

    x1_dataset =
      Plox.Dataset.new(x1_data,
        x: {x_axis, & &1.x},
        y: {y_axis, & &1.y}
      )

    x2_data = [
      %{x: 7, y: 1},
      %{x: 9, y: 3}
    ]

    x2_dataset =
      Plox.Dataset.new(x2_data,
        x: {x_axis, & &1.x},
        y: {y_axis, & &1.y}
      )

    assign(socket,
      logo_graph: %{
        dimensions: dimensions,
        x_axis: x_axis,
        y_axis: y_axis,
        p_dataset: p_dataset,
        l_dataset: l_dataset,
        o_dataset: o_dataset,
        x1_dataset: x1_dataset,
        x2_dataset: x2_dataset
      }
    )
  end

  defp logo_graph(assigns) do
    ~H"""
    <h2>Logo graph</h2>

    <.graph dimensions={@dimensions}>
      <.x_axis_labels :let={value} axis={@x_axis}>
        {value}
      </.x_axis_labels>

      <.y_axis_labels :let={value} axis={@y_axis} ticks={7}>
        {value}
      </.y_axis_labels>

      <.x_axis_grid_lines axis={@x_axis} stroke="#D3D3D3" />

      <.y_axis_grid_lines axis={@y_axis} ticks={7} stroke="#D3D3D3" />

      <.polyline points={Enum.zip(@p_dataset[:x], @p_dataset[:y])} stroke-width="5" stroke="#FF9330" />
      <.polyline points={Enum.zip(@l_dataset[:x], @l_dataset[:y])} stroke-width="5" stroke="#78C348" />
      <.polyline points={Enum.zip(@o_dataset[:x], @o_dataset[:y])} stroke-width="5" stroke="#71AEFF" />
      <.polyline
        points={Enum.zip(@x1_dataset[:x], @x1_dataset[:y])}
        stroke-width="5"
        stroke="#FF7167"
      />
      <.polyline
        points={Enum.zip(@x2_dataset[:x], @x2_dataset[:y])}
        stroke-width="5"
        stroke="#FF7167"
      />
    </.graph>
    """
  end
end

PhoenixPlayground.start(live: DemoLive)
