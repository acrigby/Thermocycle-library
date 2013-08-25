within ThermoCycle.Components.Units.HeatExchangers;
model Hx1DInc
extends Components.Units.BaseUnits.BaseHx;

/******************************* COMPONENTS ***********************************/

  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim
                                         WorkingFluid(redeclare package Medium
      =                                                                          Medium1,
  redeclare final model Flow1DimHeatTransferModel =
        Medium1HeatTransferModel,
    N=N,
    A=A_wf,
    V=V_wf,
    pstart=pstart_wf,
    Mdotnom=Mdotnom_wf,
    Mdotconst=Mdotconst_wf,
    max_der=max_der_wf,
    filter_dMdt=filter_dMdt_wf,
    max_drhodt=max_drhodt_wf,
    TT=TT_wf,
    Unom_l=Unom_l,
    Unom_tp=Unom_tp,
    Unom_v=Unom_v,
    steadystate=steadystate_h_wf,
    Tstart_inlet=Tstart_inlet_wf,
    Tstart_outlet=Tstart_outlet_wf,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{-50,-118},{40,-32}})));
  Components.HeatFlow.Walls.MetalWall metalWall(M_wall=M_wall, c_wall=c_wall,
    Aext=A_wf,
    Aint=A_sf,
    N=N,
    Tstart_wall_1=(Tstart_inlet_wf + Tstart_outlet_sf)/2,
    Tstart_wall_end=(Tstart_outlet_wf + Tstart_inlet_sf)/2,
    steadystate_T_wall=steadystate_T_wall)
    annotation (Placement(transformation(extent={{-47,-44},{39,20}})));
  Components.HeatFlow.Walls.CountCurr countCurr(N=N)
  annotation (Placement(transformation(extent={{-45,50},{37,5}})));
 ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc   SecondaryFluid(
    redeclare package Medium = Medium2,
    redeclare final model Flow1DimIncHeatTransferModel =
        Medium2HeatTransferModel,
    N=N,
    A=A_sf,
    V=V_sf,
    Mdotnom=Mdotnom_sf,
    Unom=Unom_sf,
    pstart=pstart_sf,
    Tstart_inlet=Tstart_inlet_sf,
    Tstart_outlet=Tstart_outlet_sf,
    steadystate=steadystate_h_sf,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{46,129},{-42,39}})));

/******************************** GEOMETRIES ***********************************/

parameter Integer N=5 "Number of nodes for the heat exchanger";
parameter Modelica.SIunits.Volume V_sf= 0.03781 "Volume secondary fluid";
parameter Modelica.SIunits.Volume V_wf= 0.03781 "Volume primary fluid";
parameter Modelica.SIunits.Area A_sf = 16.18 "Area secondary fluid";
parameter Modelica.SIunits.Area A_wf = 16.18 "Area primary fluid";

/*************************** HEAT TRANSFER ************************************/
/*Secondary fluid*/
replaceable model Medium2HeatTransferModel =
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_sf = 369
    "Coefficient of heat transfer, secondary fluid" annotation (Dialog(group="Heat transfer", tab="General"));

/*Working fluid*/
replaceable model Medium1HeatTransferModel =
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=300
    "if HTtype = LiqVap: heat transfer coeff, liquid zone." annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=700
    "if HTtype = LiqVap: heat transfer coeff, two-phase zone." annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=400
    "if HTtype = LiqVap: heat transfer coeff, vapor zone." annotation (Dialog(group="Heat transfer", tab="General"));

/*********************** METAL WALL   *******************************/
parameter Modelica.SIunits.Mass M_wall= 69
    "Mass of the metal wall between the two fluids";
parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 500
    "Specific heat capacity of metal wall";

/*******************************  MASS FLOW   ***************************/

parameter Modelica.SIunits.MassFlowRate Mdotnom_sf= 3
    "Nominal flow rate of secondary fluid";
parameter Modelica.SIunits.MassFlowRate Mdotnom_wf= 0.2588
    "Nominal flow rate of working fluid";

/***************************** INITIAL VALUES **********************************/

  /*pressure*/
parameter Modelica.SIunits.Pressure pstart_sf = 1e5
    "Nominal inlet pressure of secondary fluid"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Pressure pstart_wf= 23.57e5
    "Nominal inlet pressure of working fluid"  annotation (Dialog(tab="Initialization"));
/*Temperatures*/
parameter Modelica.SIunits.Temperature Tstart_inlet_wf = 334.9
    "Initial value of working fluid temperature at the inlet"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet_wf = 413.15
    "Initial value of working fluid temperature at the outlet"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_inlet_sf = 418.15
    "Initial value of secondary fluid temperature at the inlet"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet_sf = 408.45
    "Initial value of secondary fluid temperature at the outlet"  annotation (Dialog(tab="Initialization"));
/*steady state */
 parameter Boolean steadystate_h_sf=false
    "if true, sets the derivative of T_sf (secondary fluids Temperature in each cell) to zero during Initialization"
    annotation (Dialog(group="Intialization options", tab="Initialization"));
parameter Boolean steadystate_h_wf=false
    "if true, sets the derivative of h of primary fluid (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Intialization options", tab="Initialization"));
parameter Boolean steadystate_T_wall=false
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Intialization options", tab="Initialization"));

/*************************  NUMERICAL OPTIONS ******************************************/

  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
/*Working fluid*/
  parameter Boolean Mdotconst_wf=false
    "Set to yes to assume constant mass flow rate of primary fluid at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der_wf=false
    "Set to yes to limit the density derivative of primary fluid during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt_wf=false
    "Set to yes to filter dMdt of primary fluid with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt_wf=100
    "Maximum value for the density derivative of primary fluid"
    annotation (Dialog(enable=max_der, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT_wf=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
//Variables
protected
Modelica.SIunits.Power Q_sf_;
Modelica.SIunits.Power Q_wf_;
public
record SummaryBase
  replaceable Arrays T_profile;
  record Arrays
   parameter Integer n;
   Modelica.SIunits.Temperature[n] Tsf;
   Modelica.SIunits.Temperature[n] Twall;
   Modelica.SIunits.Temperature[n] Twf;
   Real PinchPoint;
  end Arrays;
  Modelica.SIunits.Pressure p_sf;
  Modelica.SIunits.Pressure p_wf;
  Modelica.SIunits.Power Q_sf;
  Modelica.SIunits.Power Q_wf;
end SummaryBase;
replaceable record SummaryClass = SummaryBase;
SummaryClass Summary( T_profile( n=N, Tsf = SecondaryFluid.Summary.T[end:-1:1],  Twall = metalWall.T_wall, Twf = WorkingFluid.Cells.T,PinchPoint = min(SecondaryFluid.Summary.T[end:-1:1]-WorkingFluid.Cells.T)), p_sf = SecondaryFluid.pstart, p_wf = WorkingFluid.Summary.p,Q_sf = Q_sf_,Q_wf = Q_wf_);
equation
/*Heat flow */
Q_sf_ = -SecondaryFluid.Q_tot;
Q_wf_ = WorkingFluid.Q_tot;
  connect(countCurr.side1, metalWall.Wall_int) annotation (Line(
      points={{-4,20.75},{-4,-2.4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(metalWall.Wall_ext, WorkingFluid.Wall_int) annotation (Line(
      points={{-4.86,-21.6},{-4.86,-36.8},{-5,-36.8},{-5,-57.0833}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(SecondaryFluid.Wall_int, countCurr.side2) annotation (Line(
      points={{2,65.25},{2,47.75},{-4,47.75},{-4,34.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(outlet_fl2, SecondaryFluid.OutFlow) annotation (Line(
      points={{-98,58},{-72,58},{-72,83.625},{-34.6667,83.625}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SecondaryFluid.InFlow, inlet_fl2) annotation (Line(
      points={{38.6667,84},{54,84},{54,82},{60,82},{60,60},{98,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(inlet_fl1, WorkingFluid.InFlow) annotation (Line(
      points={{-90,-50},{-52,-50},{-52,-75},{-42.5,-75}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(WorkingFluid.OutFlow, outlet_fl1) annotation (Line(
      points={{32.5,-74.6417},{64,-74.6417},{64,-50},{96,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{
            -130,-130},{130,130}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=
            true, extent={{-130,-130},{130,130}}),
                                      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-100,56},{-80,76},{-60,56},{-40,76},{-20,56},{0,76},{20,
              56},{40,76},{60,56},{80,76},{100,56}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-100,-48},{-78,-28},{-60,-48},{-40,-28},{-20,-48},{0,-28},
              {20,-48},{40,-28},{60,-48},{80,-28},{100,-48}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5)}));
end Hx1DInc;
