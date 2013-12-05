// Measurements
MirrorRadius = 18.96;
MirrorHeight = 3.3;
MirrorCircleWallThickness = 2.016;
MirrorCircleWallBufferSpace = .2;
MirrorCircleWallHeight = 4.95;

// Mirror
// translate([0,0,1.15]) color("Gainsboro") cylinder(3.3,MirrorRadius,MirrorRadius);

// Mirror Circle Holder
mirrorCircleRadius = MirrorRadius+MirrorCircleWallBufferSpace+MirrorCircleWallThickness;
difference() {
	color(0.9,0.6,1,0.1)
	cylinder(MirrorCircleWallHeight,mirrorCircleRadius,mirrorCircleRadius); // Circle
	translate([0,0,1.15]) cylinder(MirrorCircleWallHeight,MirrorRadius+MirrorCircleWallBufferSpace,MirrorRadius+MirrorCircleWallBufferSpace); // Hole
} 

// Mirror Ball
MirrorBallOffset = 8;
MirrorBallRadius = 5;
mirrorCircleZeroZ = MirrorCircleWallHeight/2;
translate([mirrorCircleRadius+MirrorBallOffset,0,mirrorCircleZeroZ]) sphere(MirrorBallRadius);

// Mirror: Circle-Ball connector
connectorCube = [MirrorBallOffset-MirrorBallRadius+MirrorCircleWallThickness*2,MirrorBallRadius,MirrorCircleWallHeight-1];
connectorStartPoint = [mirrorCircleRadius-MirrorCircleWallThickness,0,mirrorCircleZeroZ];

connectorCenter = forVectorAtIndexAddNum(connectorStartPoint,0,connectorCube[0]/2);
cutCylinderRadius = 5;
cutCylinderCenter = forVectorAtIndexAddNum(connectorCenter,1,cutCylinderRadius+1);
difference() {
	cubeStartCenteredOnPoint(connectorCube, connectorStartPoint);
	//cylinder side cut
	translate(cutCylinderCenter)
	cylinder(h=10,r=cutCylinderRadius,center=true, $fn=50);
}

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