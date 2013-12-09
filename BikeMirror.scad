// Measurements
MirrorRadius = 18.96;
MirrorHeight = 3.3;
MirrorCircleWallThickness = 2.016;
MirrorCircleWallBufferSpace = .2;
MirrorCircleWallHeight = 4.95;

// Mirror Ball
MirrorBallOffset = 8;
MirrorBallRadius = 5;

// Derived measurements
mirrorCircleRadius = MirrorRadius+MirrorCircleWallBufferSpace+MirrorCircleWallThickness;
mirrorCircleZeroZ = MirrorCircleWallHeight/2;

// Derived Objects
connectorCube = [MirrorBallOffset-MirrorBallRadius+MirrorCircleWallThickness*2,MirrorBallRadius,MirrorCircleWallHeight-1];
connectorStartPoint = [mirrorCircleRadius-MirrorCircleWallThickness,0,mirrorCircleZeroZ];

// Build Object
// bikeMirrorAndBall();

module bikeMirror() {
	translate([0,0,1.15]) color("Gainsboro") cylinder(3.3,MirrorRadius,MirrorRadius);
}

module mirrorCircleHolder() {
	difference() {
		color(0.9,0.6,1,0.1)
		cylinder(MirrorCircleWallHeight,mirrorCircleRadius,mirrorCircleRadius); // Circle
		translate([0,0,1.15]) cylinder(MirrorCircleWallHeight,MirrorRadius+MirrorCircleWallBufferSpace,MirrorRadius+MirrorCircleWallBufferSpace); // Hole
	} 
}

module mirrorBall() {
	translate([mirrorCircleRadius+MirrorBallOffset,0,mirrorCircleZeroZ]) sphere(MirrorBallRadius);
}

connectorCenter = forVectorAtIndexAddNum(connectorStartPoint,0,connectorCube[0]/2);
cutCylinderRadius = 4.5;
cutCylinderCenter = forVectorAtIndexAddNum(connectorCenter,1,cutCylinderRadius+1.5);
module mirrorCircleBallConnector() {
	difference() {
		cubeStartCenteredOnPoint(connectorCube, connectorStartPoint);
		//cylinder side cut
		translate(cutCylinderCenter) 
		cylinder(h=10,r=cutCylinderRadius,center=true, $fn=50);
		mirror([0,-1,0])
		translate(cutCylinderCenter) 
		cylinder(h=10,r=cutCylinderRadius,center=true, $fn=50);
		
	}
}

module bikeMirrorAndBall() {
	// bikeMirror();
	mirrorCircleHolder();
	mirrorBall();
	mirrorCircleBallConnector();
}

///////////////////
///// UTILITIES
///////////////////
function forVectorAtIndexAddNum(vector,index,num) = [index==0?vector[0]+num:vector[0],
													index==1?vector[1]+num:vector[1],
													index==2?vector[2]+num:vector[2]];


module cubeStartCenteredOnPoint(c,p) {
	yOffset = c[1]/2;
	zOffset = c[2]/2;
	echo("p:", p);
	translate([p[0],p[1]-yOffset,p[2]-zOffset]) {
		cube(c);
	}
}

/////////////////
// Main beam
/////////////////
// Constants
SpoonHoleLessPercentage = 1/3;
SpoonArmInsetAngle = 2;

// Derived Vars
spoonRadius = MirrorBallRadius*1.2;
spoonCutterCube = [(spoonRadius+1)*2,spoonRadius+1,(spoonRadius+1)*2];
barCube = [10, spoonRadius/2,spoonRadius*.75];
spoonArmCube = [24.6,barCube[1],barCube[2]];
spoonArmLength = spoonRadius+barCube[0]+spoonArmCube[0];
spoonArmDriftDueToRotation = sin(SpoonArmInsetAngle)*spoonArmLength;
spoonBallLessOffset = -MirrorBallRadius*SpoonHoleLessPercentage;
spoonArmOffsetFromXAxis = MirrorBallRadius*1/20;
spoonArmFootDistanceFromXAxis = spoonArmDriftDueToRotation+abs(spoonArmOffsetFromXAxis*2);
spoonArmFootXTravel = cos(SpoonArmInsetAngle)*spoonArmLength;
armsCapCube = [5,(spoonArmFootDistanceFromXAxis+spoonArmCube[1])*2,spoonArmCube[2]];

// Build Object
spoonArms();
spoonArmsJoint();

// resize([10,20,30])


module spoonHalf() {
	difference() {
		sphere(spoonRadius);
		translate([-spoonCutterCube[0]/2,-spoonCutterCube[1],-spoonCutterCube[2]/2]) cube(spoonCutterCube);
	}
}

module spoonBlankWithHead() {
	hull() {
		spoonHalf();
		translate([spoonRadius, 0, -barCube[2]/2]) cube(barCube);
	}
}

module spoonWithHead() {
	difference() {
		spoonBlankWithHead();
		translate([0,spoonBallLessOffset,0]) sphere(MirrorBallRadius);
	}
		// translate([016,-MirrorBallRadius*SpoonHoleLessPercentage,0]) sphere(MirrorBallRadius);
}

module spoonArmWithOffset() {
	translate([-spoonRadius,spoonArmOffsetFromXAxis,0]) {
	// translate([-spoonRadius,0,0]) {
		rotate([0,0,SpoonArmInsetAngle]) {
			translate([spoonRadius,0,0]) {
				spoonWithHead();
				// add Arm
				translate([spoonRadius+barCube[0],0,-barCube[2]/2]) cube(spoonArmCube);
			}
		}
	}
}

module spoonArms() {
	spoonArmWithOffset();
	mirror([0,1,0]) spoonArmWithOffset();
}

module spoonArmsJoint() {
	difference() {
		hull() {
			translate([spoonArmFootXTravel-0.5,-armsCapCube[1]/2,-spoonArmCube[2]/2]) cube(armsCapCube);
			translate([spoonArmFootXTravel+2,-spoonArmCube[1],-spoonArmCube[2]/2]) cube([20,spoonArmCube[1]*2,spoonArmCube[2]]);
		}
		translate([spoonArmFootXTravel,0,-1/2*spoonArmCube[2]-0.5]) cylinder(spoonArmCube[2]+1, r=spoonArmFootDistanceFromXAxis, $fn=20);
	}
}

