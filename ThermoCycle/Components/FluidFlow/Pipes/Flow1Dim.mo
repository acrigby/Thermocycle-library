within ThermoCycle.Components.FluidFlow.Pipes;
model Flow1Dim
  "1-D fluid flow model (finite volume discretization - real fluid model). Based on the cell component"
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
public
 record SummaryClass
   replaceable Arrays T_profile;
    record Arrays
    parameter Integer n;
      Modelica.Units.SI.Temperature[n] T_cell;
    end Arrays;
    parameter Integer n;
    Modelica.Units.SI.SpecificEnthalpy[n] h;
    Modelica.Units.SI.SpecificEnthalpy[n + 1] hnode;
    Modelica.Units.SI.Density[n] rho;
    Modelica.Units.SI.MassFlowRate[n + 1] Mdot;
    Real[n] x;
    Modelica.Units.SI.Pressure p;
 end SummaryClass;
 SummaryClass Summary( T_profile( n=N,T_cell = Cells[:].T), n=N, h = Cells[:].h, hnode = hnode_, rho = Cells.rho, Mdot = Mdot_, x=Cells.x, p = Cells[1].p);
/************ Thermal and fluid ports ***********/
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort Wall_int(N=N)
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));
/************ Geometric characteristics **************/
parameter Integer Nt(min=1)=1 "Number of cells in parallel";
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Integer N(min=1)=10 "Number of cells";
  parameter Modelica.Units.SI.Area A=16.18
    "Lateral surface of the tube: heat exchange area";
  parameter Modelica.Units.SI.Volume V=0.03781 "Volume of the tube";
  final parameter Modelica.Units.SI.Volume Vi=V/N "Volume of a single cell";
  final parameter Modelica.Units.SI.Area Ai=A/N
    "Lateral surface of a single cell";
  parameter Modelica.Units.SI.MassFlowRate Mdotnom=0.2588
    "Nominal fluid flow rate";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Unom_l=100
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone ";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Unom_tp=100
    "if HTtype = LiqVap : heat transfer coefficient, two-phase zone";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer Unom_v=100
    "if HTtype = LiqVap : heat transfer coefficient, vapor zone";
 /************ FLUID INITIAL VALUES ***************/
  parameter Modelica.Units.SI.Pressure pstart "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_inlet "Inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_outlet "Outlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart[N]=linspace(
        Medium.specificEnthalpy_pT(pstart,Tstart_inlet),Medium.specificEnthalpy_pT(pstart,Tstart_outlet),
        N) "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/******************************** NUMERICAL OPTIONS  ********************************************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt=100 "Maximum value for the density derivative"
    annotation (Dialog(enable=max_der, tab="Numerical options"));
  parameter Modelica.Units.SI.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
  parameter Boolean steadystate=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
     annotation (Dialog(group="Initialization options", tab="Initialization"));
/******************************* HEAT TRANSFER MODEL **************************************/
replaceable model Flow1DimHeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Fluid heat transfer model" annotation (choicesAllMatching = true);
/***************  VARIABLES ******************/
  Modelica.Units.SI.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.Units.SI.Mass M_tot "Total mass of the fluid in the component";
  Medium.SaturationProperties  sat
    "Calculation of the saturation properties here to avoid calculating in every cell";
 replaceable ThermoCycle.Components.FluidFlow.Pipes.Cell1Dim
        Cells[N](
    redeclare each final package Medium = Medium,
    redeclare each final model HeatTransfer = Flow1DimHeatTransferModel,
    each Vi=V/N,
    each Ai=A/N,
    each Nt=Nt,
    each Mdotnom=Mdotnom,
    each Unom_l=Unom_l,
    each Unom_tp=Unom_tp,
    each Unom_v=Unom_v,
    each pstart=pstart,
    each Discretization=Discretization,
    each Mdotconst=Mdotconst,
    each max_der=max_der,
    each filter_dMdt=filter_dMdt,
    each max_drhodt=max_drhodt,
    each TT=TT,
    each steadystate=steadystate,
    hstart = hstart,
    each sat_in= {sat.psat,sat.Tsat},
    each ComputeSat = false)
            annotation (Placement(transformation(extent={{-26,-56},{28,-12}})));
  Interfaces.HeatTransfer.ThermalPortConverter
                       thermalPortConverter(N=N)
    annotation (Placement(transformation(extent={{-10,6},{10,26}})));
protected
  Modelica.Units.SI.SpecificEnthalpy hnode_[N + 1];
  Modelica.Units.SI.MassFlowRate Mdot_[N + 1];
equation
  // Connect refrigerant cells with eachother
  for i in 1:N-1 loop
    connect(Cells[i].OutFlow, Cells[i+1].InFlow);
  end for;
  sat = Medium.setSat_p(Cells[1].p);
  hnode_[1:N] = Cells.hnode_su;
  hnode_[N+1] = Cells[N].hnode_ex;
  Mdot_[1:N] = Cells.M_dot_su;
  Mdot_[N+1] = Cells[N].M_dot_ex;
  Q_tot = A/N*sum(Cells.qdot)*Nt "Total heat flow through the thermal port";
  M_tot = V/N*sum(Cells.rho);
  connect(InFlow, Cells[1].InFlow) annotation (Line(
      points={{-90,0},{-60,0},{-60,-34},{-26,-34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Cells[N].OutFlow, OutFlow) annotation (Line(
      points={{28,-33.78},{57,-33.78},{57,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(thermalPortConverter.single, Cells.Wall_int) annotation (Line(
      points={{0,11.9},{0,-9.05},{1,-9.05},{1,-23}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalPortConverter.multi, Wall_int) annotation (Line(
      points={{0,19.5},{0,48},{2,50}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-120},
            {120,120}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
                  extent={{-120,-120},{120,120}}),
                                      graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-92,24},{88,-20}},
          lineColor={0,0,255},
          textString="%FLow1D")}),Documentation(info="<HTML>
          <p><big>This model describes the flow of fluid through a discretized one dimensional tube. It is obtained by connecting in series <b>N</b>  <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Cell1Dim\">Cell1Dim</a>. The
          resulting discretization scheme is of the staggered type i.e. state variables are computed at the center of each cell and the node variables are calculated depending on the local discretization  (Upwind or Central difference). 
          <p><big> The <b>Modelling options</b> and the <b>Numerical options</b> are the same as the one presented in the Cell1D model documentation.
          
          <p><big> The model is characterized by a SummaryClass that provide a quick access to the following variables once the model is simulated:
           <ul><li> Enthalpy at each node
           <li>  Enthalpy at the center of each cell
           <li> Density at the center of each cell
           <li> Massflow at each nodes
           <li> Vapor quality at the center of each cell
           <li> Pressure in the tube
           </ul>
          
       </HTML>"));
end Flow1Dim;
