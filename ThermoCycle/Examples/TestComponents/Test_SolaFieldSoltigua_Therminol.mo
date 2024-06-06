within ThermoCycle.Examples.TestComponents;
model Test_SolaFieldSoltigua_Therminol

parameter Real VV=0;
ThermoCycle.Components.Units.Solar.SolarField_Soltigua_Inc        solarCollectorIncSchott(
    Mdotnom=0.5,
    Ns=2,
    redeclare
      ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Soltigua.PTMx_18
      CollectorGeometry,
    redeclare model FluidHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    redeclare package Medium1 =
        TRANSFORM.Media.Fluids.Therminol_66.TableBasedTherminol66,
    Tstart_inlet=298.15,
    Tstart_outlet=373.15,
    pstart=1000000)
    annotation (Placement(transformation(extent={{-34,-28},{8,42}})));

  Modelica.Blocks.Sources.Constant const(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-118,-22},{-98,-2}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-118,12},{-98,32}})));
  Modelica.Blocks.Sources.Constant const3(k=0)
    annotation (Placement(transformation(extent={{-98,44},{-78,64}})));
  Modelica.Blocks.Sources.Step step(
    startTime=100,
    height=1000,
    offset=VV)
    annotation (Placement(transformation(extent={{-110,-54},{-90,-34}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-162,-74},{-142,-54}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium =
        TRANSFORM.Media.Fluids.Therminol_66.TableBasedTherminol66,
    m_flow=0.5,
    T=298.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,-88},{-20,-68}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium =
        TRANSFORM.Media.Fluids.Therminol_66.TableBasedTherminol66,
    p=200000,
    T=423.15,
    nPorts=1) annotation (Placement(transformation(extent={{34,54},{14,74}})));
equation
  connect(const3.y, solarCollectorIncSchott.v_wind) annotation (Line(
      points={{-77,54},{-56,54},{-56,34},{-31.2,34},{-31.2,36.2727}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, solarCollectorIncSchott.Theta) annotation (Line(
      points={{-97,22},{-48,22},{-48,22.9091},{-31.6667,22.9091}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, solarCollectorIncSchott.Tamb) annotation (Line(
      points={{-97,-12},{-54,-12},{-54,8.90909},{-31.6667,8.90909}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(step.y, solarCollectorIncSchott.DNI) annotation (Line(
      points={{-89,-44},{-56,-44},{-56,-4.13636},{-31.9,-4.13636}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanConstant.y, solarCollectorIncSchott.Defocusing) annotation (
      Line(
      points={{-141,-64},{-110,-64},{-110,-68},{-68,-68},{-68,-17.8182},{
          -31.6667,-17.8182}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(boundary.ports[1], solarCollectorIncSchott.InFlow) annotation (Line(
        points={{-20,-78},{-8.8,-78},{-8.8,-28.6364}}, color={0,127,255}));
  connect(boundary1.ports[1], solarCollectorIncSchott.OutFlow) annotation (Line(
        points={{14,64},{-6,64},{-6,41.3636}}, color={0,127,255}));
  annotation (
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_SolaFieldSoltigua_Therminol;
