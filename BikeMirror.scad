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
bikeMirrorAndBall();

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
// Cup

// Derived Vars
spoonRadius = MirrorBallRadius*1.2;
spoonCutterCube = [(spoonRadius+1)*2,spoonRadius+1,(spoonRadius+1)*2];
barCube = [10, spoonRadius/2,spoonRadius*.75];

// Build Object
// spoonWithHead();

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
		sphere(MirrorBallRadius);
	}
}

