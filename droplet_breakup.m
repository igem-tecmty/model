function out = model

ModelUtil.showProgress(true)

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Program Files\COMSOL\COMSOL51\Multiphysics\applications\CFD_Module\Multiphase_Benchmarks');

model.comments(['Untitled\n\n']);

model.modelNode.create('comp1');

model.geom.create('geom1', 3);

model.mesh.create('mesh1', 'geom1');

model.physics.create('tpf', 'LaminarTwoPhaseFlowLevelSet', 'geom1');

model.study.create('std1');
model.study('std1').create('phasei', 'PhaseInitialization');
model.study('std1').feature('phasei').activate('tpf', true);
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('tpf', true);

model.geom('geom1').lengthUnit('mm');
model.geom('geom1').feature.create('wp1', 'WorkPlane');
model.geom('geom1').feature('wp1').set('unite', true);
model.geom('geom1').feature('wp1').set('quickplane', 'xz');
model.geom('geom1').feature('wp1').geom.create('r1', 'Rectangle');
model.geom('geom1').feature('wp1').geom.feature('r1').set('size', {'0.1' '0.4'});
model.geom('geom1').feature('wp1').geom.feature('r1').set('pos', {'0' '0.1'});
model.geom('geom1').feature('wp1').geom.run('r1');
model.geom('geom1').feature('wp1').geom.create('r2', 'Rectangle');
model.geom('geom1').feature('wp1').geom.feature('r2').set('size', {'1' '0.1'});
model.geom('geom1').feature('wp1').geom.feature('r2').set('pos', {'-0.7' '0'});
model.geom('geom1').feature('wp1').geom.run('r2');
model.geom('geom1').feature('wp1').geom.run('r2');
model.geom('geom1').feature('wp1').geom.create('pol1', 'Polygon');
model.geom('geom1').feature('wp1').geom.feature('pol1').set('type', 'open');
model.geom('geom1').feature('wp1').geom.feature('pol1').set('x', '0 0.1');
model.geom('geom1').feature('wp1').geom.feature('pol1').set('y', '0.2 0.2');
model.geom('geom1').feature('wp1').geom.run('pol1');
model.geom('geom1').feature('wp1').geom.run('pol1');
model.geom('geom1').feature('wp1').geom.create('pol2', 'Polygon');
model.geom('geom1').feature('wp1').geom.feature('pol2').set('x', '0.1 0.1');
model.geom('geom1').feature('wp1').geom.feature('pol2').set('y', '0 0.1');
model.geom('geom1').feature('wp1').geom.run('pol2');
model.geom('geom1').run('wp1');
model.geom('geom1').feature.create('ext1', 'Extrude');
model.geom('geom1').feature('ext1').set('workplane', 'wp1');
model.geom('geom1').feature('ext1').selection('input').set({'wp1'});
model.geom('geom1').feature('ext1').setIndex('distance', '0.05', 0);
model.geom('geom1').run('ext1');
model.geom('geom1').run('fin');

model.material.create('mat1', 'Common', 'comp1');
model.material('mat1').label('Fluid 1');
model.material('mat1').propertyGroup('def').set('density', {'1e3[kg/m^3]'});
model.material('mat1').propertyGroup('def').set('dynamicviscosity', {'1.95e-3[Pa*s]'});
model.material.create('mat2', 'Common', 'comp1');
model.material('mat2').label('Fluid 2');
model.material('mat2').propertyGroup('def').set('density', '');
model.material('mat2').propertyGroup('def').set('dynamicviscosity', '');
model.material('mat2').propertyGroup('def').set('density', {'1e3[kg/m^3]'});
model.material('mat2').propertyGroup('def').set('dynamicviscosity', {'6.71e-3[Pa*s]'});

model.func.create('step1', 'Step');
model.func('step1').model('comp1');
model.func('step1').set('location', '1e-3');
model.func('step1').set('smooth', '2e-3');

model.cpl.create('intop1', 'Integration', 'geom1');
model.cpl('intop1').selection.all;

model.variable.create('var1');
model.variable('var1').model('comp1');
%Volume Flow Continous phase
model.variable('var1').set('V1', '0.4e-6/3600*step1(t[1/s])[m^3/s]');
model.variable('var1').descr('V1', 'Volume flow, inlet 1');
%Volume Flow Disperse phase
model.variable('var1').set('V2', '0.2e-6/3600*step1(t[1/s])[m^3/s]');
model.variable('var1').descr('V2', 'Volume flow, inlet 2');
%Droplet size
model.variable('var1').set('d_eff', '2*(intop1((phils>0.5)*(x<-0.2[mm]))*3/(4*pi))^(1/3)');
model.variable('var1').descr('d_eff', 'Effective droplet diameter');

model.physics('tpf').prop('ShapeProperty').set('order_fluid', '1');
model.physics('tpf').feature('fp1').setIndex('Fluid1', 'mat1', 0);
model.physics('tpf').feature('fp1').setIndex('Fluid2', 'mat2', 0);
model.physics('tpf').feature('fp1').setIndex('SurfaceTensionCoefficient', 'userdef', 0);
model.physics('tpf').feature('fp1').setIndex('sigma', '5e-3[N/m]', 0);
model.physics('tpf').feature('fp1').setIndex('gamma', '0.05[m/s]', 0);
model.physics('tpf').feature('fp1').setIndex('epsilon_ls', '5e-6[m]', 0);
model.physics('tpf').feature('wall1').setIndex('BoundaryCondition', 'WettedWall', 0);
model.physics('tpf').feature('wall1').setIndex('thetaw', '3*pi/4[rad]', 0);
model.physics('tpf').feature('wall1').setIndex('beta', '5e-6[m]', 0);
model.physics('tpf').feature('ii1').selection.set([11]);
model.physics('tpf').feature.create('init2', 'init', 3);
model.physics('tpf').feature('init2').selection.set([3]);
model.physics('tpf').feature('init2').set('FluidInitiallyInDomain', 'Fluid2');
model.physics('tpf').feature.create('inl1', 'InletBoundary', 2);
model.physics('tpf').feature('inl1').selection.set([22]);
model.physics('tpf').feature('inl1').set('BoundaryCondition', 'LaminarInflow');
model.physics('tpf').feature('inl1').set('LaminarInflowOption', 'V0');
model.physics('tpf').feature('inl1').set('V0', 'V1');
model.physics('tpf').feature('inl1').set('Lentr', '0.01[m]');
model.physics('tpf').feature.create('inl2', 'InletBoundary', 2);
model.physics('tpf').feature('inl2').selection.set([12]);
model.physics('tpf').feature('inl2').set('phi0', '1');
model.physics('tpf').feature('inl2').set('BoundaryCondition', 'LaminarInflow');
model.physics('tpf').feature('inl2').set('LaminarInflowOption', 'V0');
model.physics('tpf').feature('inl2').set('V0', 'V2');
model.physics('tpf').feature('inl2').set('Lentr', '0.01[m]');
model.physics('tpf').feature.create('out1', 'OutletBoundary', 2);
model.physics('tpf').feature('out1').selection.set([1]);
model.physics('tpf').feature.create('sym1', 'SymmetryFluid', 2);
model.physics('tpf').feature('sym1').selection.set([5 13 14 21]);

model.mesh('mesh1').create('map1', 'Map');
model.mesh('mesh1').feature('map1').selection.set([2 7 10 16]);
model.mesh('mesh1').feature('map1').create('dis1', 'Distribution');
model.mesh('mesh1').feature('map1').feature('dis1').selection.set([3]);
model.mesh('mesh1').feature('map1').feature('dis1').set('numelem', '160');
model.mesh('mesh1').feature('map1').create('dis2', 'Distribution');
model.mesh('mesh1').feature('map1').feature('dis2').selection.set([1 9]);
model.mesh('mesh1').feature('map1').feature('dis2').set('numelem', '20');
model.mesh('mesh1').feature('map1').create('dis3', 'Distribution');
model.mesh('mesh1').feature('map1').feature('dis3').selection.set([12 28]);
model.mesh('mesh1').feature('map1').feature('dis3').set('type', 'predefined');
model.mesh('mesh1').feature('map1').feature('dis3').set('elemcount', '25');
model.mesh('mesh1').feature('map1').feature('dis3').set('elemratio', '4');
model.mesh('mesh1').feature('map1').create('dis4', 'Distribution');
model.mesh('mesh1').feature('map1').feature('dis4').selection.set([24 27]);
model.mesh('mesh1').feature('map1').feature('dis4').set('type', 'predefined');
model.mesh('mesh1').feature('map1').feature('dis4').set('elemcount', '20');
model.mesh('mesh1').feature('map1').feature('dis4').set('elemratio', '3');
model.mesh('mesh1').feature('map1').feature('dis4').set('reverse', 'on');
model.mesh('mesh1').run('map1');
model.mesh('mesh1').create('swe1', 'Sweep');
model.mesh('mesh1').feature('swe1').selection('sourceface').set([2 7 10]);
model.mesh('mesh1').feature('swe1').create('dis1', 'Distribution');
model.mesh('mesh1').feature('swe1').feature('dis1').set('numelem', '10');
model.mesh('mesh1').run;

model.study('std1').feature('time').set('tlist', 'range(0,5e-3,0.08)');
model.study('std1').feature('time').set('plot', 'on');

model.sol.create('sol1');
model.sol('sol1').study('std1');

model.study('std1').feature('phasei').set('notlistsolnum', 1);
model.study('std1').feature('phasei').set('notsolnum', '1');
model.study('std1').feature('phasei').set('listsolnum', 1);
model.study('std1').feature('phasei').set('solnum', '1');
model.study('std1').feature('time').set('notlistsolnum', 1);
model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('listsolnum', 1);
model.study('std1').feature('time').set('solnum', 'auto');

model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'phasei');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'phasei');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('dtech', 'auto');
model.sol('sol1').feature('s1').feature('fc1').set('initstep', 0.01);
model.sol('sol1').feature('s1').feature('fc1').set('minstep', 1.0E-6);
model.sol('sol1').feature('s1').feature('fc1').set('maxiter', 50);
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('s1').feature('i1').set('prefuntype', 'left');
model.sol('sol1').feature('s1').feature('i1').set('rhob', 40);
model.sol('sol1').feature('s1').feature('i1').set('itrestart', 50);
model.sol('sol1').feature('s1').feature('i1').set('maxlinit', 400);
model.sol('sol1').feature('s1').feature('i1').set('nlinnormuse', 'on');
model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('prefun', 'gmg');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('mcasegen', 'any');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('iter', 2);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('linerelax', 0.2);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('seconditer', 1);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('relax', 0.4);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('iter', 2);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('linerelax', 0.2);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('seconditer', 2);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('relax', 0.4);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature('fc1').set('dtech', 'auto');
model.sol('sol1').feature('s1').feature('fc1').set('initstep', 0.01);
model.sol('sol1').feature('s1').feature('fc1').set('minstep', 1.0E-6);
model.sol('sol1').feature('s1').feature('fc1').set('maxiter', 50);
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').create('su1', 'StoreSolution');
model.sol('sol1').create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').create('v2', 'Variables');
model.sol('sol1').feature('v2').feature('comp1_phils').set('scalemethod', 'manual');
model.sol('sol1').feature('v2').feature('comp1_phils').set('scaleval', '1');
model.sol('sol1').feature('v2').set('initmethod', 'init');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('notsoluse', 'su1');
model.sol('sol1').feature('v2').set('control', 'time');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,5e-3,0.08)');
model.sol('sol1').feature('t1').set('plot', 'on');
model.sol('sol1').feature('t1').set('plotgroup', 'Default');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 5.0E-4);
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 6);
model.sol('sol1').feature('t1').create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 6);
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').feature('v2').set('listsolnum', {'1'});
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').attach('std1');
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').set('incrdelayactive', 'on');
model.sol('sol1').feature('t1').set('incrdelay', '3');
model.sol('sol1').feature('t1').set('rhoinf', '0.3');
model.sol('sol1').feature('t1').set('predictor', 'constant');
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('rhob', '20');
model.sol('sol1').feature('t1').feature('i1').set('maxlinit', '200');
model.sol('sol1').feature('t1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').create('sc1', 'SCGS');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('vankavarsactive', 'on');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('vankavars', {'comp1_tpf_Pinlinl1' 'comp1_tpf_Pinlinl2'});
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').create('sc1', 'SCGS');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('vankavarsactive', 'on');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('vankavars', {'comp1_tpf_Pinlinl1' 'comp1_tpf_Pinlinl2'});
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').feature('dDef').set('linsolver', 'pardiso');

model.sol('sol1').runAll;

model.result.create('pg1', 3);
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('slc1', 'Slice');
model.result('pg1').feature('slc1').set('expr', {'tpf.Vf1'});
model.result('pg1').label('Volume Fraction (tpf)');
model.result.create('pg2', 3);
model.result('pg2').set('data', 'dset1');
model.result('pg2').create('slc1', 'Slice');
model.result('pg2').feature('slc1').set('expr', {'tpf.U'});
model.result('pg2').create('iso1', 'Isosurface');
model.result('pg2').feature('iso1').set('expr', {'tpf.Vf1'});
model.result('pg2').feature('iso1').set('levelmethod', 'levels');
model.result('pg2').feature('iso1').set('levels', '0.5');
model.result('pg2').feature('iso1').set('coloring', 'uniform');
model.result('pg2').feature('iso1').set('color', 'gray');
model.result('pg2').label('Velocity (tpf)');
out = model;