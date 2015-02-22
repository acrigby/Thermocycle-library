within ThermoCycle.Examples.TestHXcorrelations;
model Test_HeatTransferTester "A test driver for the different implementations of 
  heat transfer models"
  extends Modelica.Icons.Example;

model InputSelector
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
      Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium"
    annotation(choicesAllMatching=true);

// Settings for heat transfer
Medium.ThermodynamicState state(phase(start=0));
// Settings for correlation
parameter Modelica.SIunits.MassFlowRate m_dot_nom = m_dot_start
      "Nomnial Mass flow rate"
                           annotation (Dialog(tab="Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_l = 1500
      "Nominal heat transfer coefficient liquid side"
                                                  annotation (Dialog(tab="Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_tp = 3000
      "Nominal heat transfer coefficient two phase side"
                                                     annotation (Dialog(tab="Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_v = 1000
      "Nominal heat transfer coefficient vapor side"
                                                 annotation (Dialog(tab="Heat transfer"));
Medium.AbsolutePressure p;
Medium.SpecificEnthalpy h;
Medium.SpecificEnthalpy h_start;
Medium.SpecificEnthalpy h_end;
Modelica.SIunits.MassFlowRate m_dot "Inlet massflow";
Real x "Vapor quality";
Real y "Relative position";
Modelica.SIunits.Time c = 10;

Medium.ThermodynamicState bubbleState(h(start=0));
    Medium.ThermodynamicState dewState(h(start=0));

replaceable model HeatTransfer =
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.MassFlowDependence
  constrainedby
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation
      "Heat transfer model"
    annotation(choicesAllMatching=true);

    HeatTransfer heatTransfer(
  redeclare final package Medium = Medium,
  final n = 1,
  FluidState = {state},
  Mdotnom = m_dot_nom,
  Unom_l =  U_nom_l,
  Unom_tp = U_nom_tp,
  Unom_v =  U_nom_v,
  M_dot = m_dot,
  x = x);

    input Modelica.SIunits.Temperature T_port=Medium.temperature(state)
      "Fixed wall temperature";
    ThermoCycle.Components.HeatFlow.Sources.Source_T_cell source_T;

    parameter Medium.AbsolutePressure p_start = 1e5 "Start pressure";
    parameter Medium.AbsolutePressure p_end = p_start "Final pressure";

    parameter Modelica.SIunits.MassFlowRate m_dot_start = 1 "Start flow rate";
    parameter Modelica.SIunits.MassFlowRate m_dot_end = m_dot_start
      "Final flow rate";

    parameter Boolean twoPhase = false "is two-phase medium?";
    parameter Medium.SpecificEnthalpy h_start_in = 0 "Start enthalpy"
      annotation(Dialog(enable = not twoPhase));

    parameter Medium.SpecificEnthalpy h_end_in = h_start_in "Final enthalpy"
      annotation(Dialog(enable = not twoPhase));

equation
  if twoPhase then
    bubbleState = Medium.setBubbleState(Medium.setSat_p(Medium.pressure(state)));
    dewState    = Medium.setDewState(   Medium.setSat_p(Medium.pressure(state)));
    x           = (Medium.specificEnthalpy(state) - Medium.specificEnthalpy(bubbleState))/(Medium.specificEnthalpy(dewState) - Medium.specificEnthalpy(bubbleState));
    h_start     = Medium.specificEnthalpy(bubbleState) - 0.55*(Medium.specificEnthalpy(dewState) - Medium.specificEnthalpy(bubbleState));
    h_end       = Medium.specificEnthalpy(dewState)    + 0.55*(Medium.specificEnthalpy(dewState) - Medium.specificEnthalpy(bubbleState));
  else
    bubbleState = state;
    dewState    = state;
    x           = 0;
    h_start     = h_start_in;
    h_end       = h_end_in;
  end if;
  y = time/c;
  p     = (1-y) * p_start     + y * p_end;
  m_dot = (1-y) * m_dot_start + y * m_dot_end;
  h     = (1-y) * h_start     + y * h_end;
  state = Medium.setState_phX(p=p,h=h);

  T_port =source_T.Temperature;
  connect(heatTransfer.thermalPortL[1], source_T.ThermalPortCell);

end InputSelector;

  InputSelector tester(
    h_start_in=100e3,
    twoPhase=true,
    redeclare package Medium = ThermoCycle.Media.R134a_CP(substanceNames={"R134a|debug=0|calc_transport=1|enable_EXTTP=1|enable_TTSE=0"}),
    m_dot_start=0.01,
    p_start=500000)
    annotation (Placement(transformation(extent={{-42,42},{-22,62}})));

  annotation (experiment(StopTime=10));
end Test_HeatTransferTester;
