within ThermoCycle.Examples.TestComponents;
model Test_Cell1D

  Components.FluidFlow.Pipes.Cell1Dim
         flow1Dim(
    Ai=0.2,
    Unom_l=400,
    Unom_tp=1000,
    Unom_v=400,
    max_drhodt=50,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    Mdotnom=0.3335,
    hstart=84867,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind,
    redeclare model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence,
    Vi=0.038,
    pstart=866735)
    annotation (Placement(transformation(extent={{-16,10},{4,30}})));

  Components.FluidFlow.Reservoirs.SourceMdot             sourceMdot1(
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    h_0=84867,
    Mdot_0=0.3334,
    UseT=true,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-72,10},{-52,30}})));
  Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
      Medium = ThermoCycle.Media.R407c_CP,
    h=254381,
    p0=866735)
    annotation (Placement(transformation(extent={{46,12},{66,32}})));
  Modelica.Blocks.Sources.Step step(
    startTime=10,
    height=-15,
    offset=83.11 + 273.15)
    annotation (Placement(transformation(extent={{-96,42},{-76,62}})));
equation
  connect(sourceMdot1.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-53,20},{-16,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{4,20.1},{25,20.1},{25,22},{47.6,22}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(step.y, sourceMdot1.in_T) annotation (Line(
      points={{-75,52},{-72,52},{-72,50},{-62.2,50},{-62.2,26}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end Test_Cell1D;
