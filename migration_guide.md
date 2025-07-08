# Plox Migration Guide (0.2.0 to 0.3.0)

Plox has gone through a major philosophical rewrite since its initial publication. This
guide will help users convert their current Plox graphs over to the new approach.

## Example of 0.2.0 usage

1. Set up data, scales, and dataset:

```elixir
data = [
  %{date: ~D[2023-08-01], value: 35.0},
  %{date: ~D[2023-08-02], value: 60.0},
  %{date: ~D[2023-08-03], value: 65.0},
  %{date: ~D[2023-08-04], value: 10.0},
  %{date: ~D[2023-08-05], value: 50.0}
]

date_scale = date_scale(Date.range(~D[2023-08-01], ~D[2023-08-05]))
number_scale = number_scale(0.0, 80.0)

dataset =
  dataset(data,
    x: {date_scale, & &1.date},
    y: {number_scale, & &1.value}
  )
```

2. Build a `Plox.Graph` struct:

```elixir
example_graph =
  to_graph(
    scales: [date_scale: date_scale, number_scale: number_scale],
    datasets: [dataset: dataset]
  )
```

3. Render the `Plox.Graph` within your HEEx template:

```html
<.graph :let={graph} id="example_graph" for={@example_graph} width="800" height="250">
  <.x_axis :let={date} scale={graph[:date_scale]}>
    {Calendar.strftime(date, "%-m/%-d")}
  </.x_axis>

  <.y_axis :let={value} scale={graph[:number_scale]} ticks={5}>
    {value}
  </.y_axis>

  <.polyline dataset={graph[:dataset]} color="#EC7E16" />

  <.circles dataset={graph[:dataset]} color="#EC7E16" />
</.graph>
```

## Example of 0.3.0 usage

1. Set up data, dimensions, axes, and dataset:

```elixir
data = [
  %{date: ~D[2023-08-01], value: 35.0},
  %{date: ~D[2023-08-02], value: 60.0},
  %{date: ~D[2023-08-03], value: 65.0},
  %{date: ~D[2023-08-04], value: 10.0},
  %{date: ~D[2023-08-05], value: 50.0}
]

# Instead of passing the height and width via the `graph` component,
# create Dimensions and pass them to each Axis
dimensions = Plox.Dimensions.new(800, 250)

# Instead of creating separate Scales, we need them when creating our Axes
x_axis = Plox.XAxis.new(
  Plox.DateScale.new(Date.range(~D[2023-08-01], ~D[2023-08-05])),
  dimensions
)

y_axis = Plox.YAxis.new(Plox.NumberScale.new(0.0, 80.0), dimensions)

# Create a Dataset with our Axes
dataset =
  Plox.Dataset.new(data,
    x: {x_axis, & &1.date},
    y: {y_axis, & &1.value}
  )
```

2. Render the `graph` component within your HEEx template:

```html
<.graph id="example_graph" dimensions={@dimensions}>
  <!-- Render axis labels and lines individually -->
  <.x_axis_labels :let={date} axis={@x_axis}>
    {Calendar.strftime(date, "%-m/%-d")}
  </.x_axis_labels>

  <.y_axis_labels :let={value} axis={@y_axis} ticks={5}>
    {value}
  </.y_axis_labels>

  <.x_axis_grid_lines axis={@x_axis} stroke="#D3D3D3" />
  <.y_axis_grid_lines axis={@y_axis} ticks={5} stroke="#D3D3D3" />

  <.polyline dataset={@dataset} stroke="#EC7E16" stroke-width={2} />

  <.circle cx={@dataset[:x]} cy={@dataset[:y]} r={3} fill="#EC7E16" />
</.graph>
```