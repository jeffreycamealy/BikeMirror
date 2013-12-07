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
	bikeMirror();
	mirrorCircleHolder();
	mirrorBall();
	mirrorCircleBallConnector();
}


// Mirror: Circle-Ball connector


// Main beam
// Cup
// SpoonRadius = 6;
// spoonCutterCube = [(SpoonRadius+1)*2,SpoonRadius+1,(SpoonRadius+1)*2];
// barCube = [10, SpoonRadius/2,SpoonRadius*.75];
// // hull() {
// 	spoonHalf();
// 	sphere(MirrorBallRadius);
// 	// translate([SpoonRadius, 0, -barCube[2]/2]) cube(barCube);
// // }

// module spoonHalf() {
// 	difference() {
// 		sphere(SpoonRadius);
// 		translate([-spoonCutterCube[0]/2,-spoonCutterCube[1],-spoonCutterCube[2]/2]) cube(spoonCutterCube);
// 	}
// }


// minkowski() {
// 	translate([-10,0,0]) scale([1,1,3]) rotate(45,[0,1,0]) cube(11,1,1);
// 	scale([1.0,2.0,3.0]) sphere(r=5.0); 
// }

// translate([0,-50,0]) scale([1,1,3]) rotate(45,[0,1,0]) cube(11,1,1);
// translate([0,-20,0]) scale([1.0,2.0,3.0]) sphere(r=5.0); 

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