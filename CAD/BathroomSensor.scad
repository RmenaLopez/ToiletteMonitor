$fn = 30;
differenceOffset = 0.01;
resinThickness = 0.2;
casingDepth = 3;
backWallCasingDepth = 2.5;
frontWallCasingDepth = casingDepth - backWallCasingDepth;
lockHeigth = 0.2;
railsForCircuitHeigth = 0.4;
railWidth = 0.2;

doubleSidedTapeThickness = 0.1;
module handle(width, depth, heigth, thickness){
    difference(){
        cube([width, depth + thickness, heigth]);
        translate([-differenceOffset / 2, -differenceOffset, - differenceOffset])cube([width + differenceOffset, depth + differenceOffset, heigth - thickness + differenceOffset]);
        }
        screwMountToDoor = 1;
    translate([0, 0, heigth - screwMountToDoor]){
        cube([width, thickness, screwMountToDoor]);
        }
    }

module slider (width, depth, heigth, thickness, sliderExceedanceWidth){
    sliderTabWidth = 3.1;
    sliderTabHeigth = 1.8;
    translate([(sin(360 * $t) * sliderExceedanceWidth/2 ) - sliderExceedanceWidth/2, 0, 0])
    union(){
    translate([0, depth - thickness, 0]){
        cube([width + sliderExceedanceWidth, thickness, heigth]);
        }
    translate([width - sliderTabWidth - sliderExceedanceWidth/2, depth - thickness, -sliderTabHeigth]){
        cube([sliderTabWidth, thickness, sliderTabHeigth]);
        }
    }
    }   
    
module lock(width, depth, heigth, thickness){
    
    sliderThickness = 0.3;
    sliderExceedanceWidth = 1.9;
    sliderHeigth = 2.5;
    
    handle(width, depth, heigth, thickness);
    
    color("cyan")slider(width, depth,sliderHeigth, sliderThickness, sliderExceedanceWidth);
    }
    
module casingBase(){ 
        polygon([
        [0,0],
        [10 + (resinThickness * 2), 0],
        [10 + (resinThickness * 2), 10.2 + (resinThickness * 2)],
        [7.5 + (resinThickness), 10.2 + (resinThickness * 2)],
        [7.5 + (resinThickness), 7 + (resinThickness * 3)],
        [0, 7 + (resinThickness * 3)]
        ]);
        }
module backWallCasing(depth){
    module notRoundedShape (){
        difference(){
            linear_extrude(depth){
                casingBase();
                }
            translate([0, 0, resinThickness]){
                linear_extrude(depth){
                    offset(-resinThickness){
                    casingBase();
                        }   
                    }
                }
            translate([0, 7 + (resinThickness * 3), resinThickness]){
                cube([10.2, 3 + resinThickness + differenceOffset, depth]);
                }
            translate([7.5 + (resinThickness), 7 + (resinThickness * 2), resinThickness]){
                cube([resinThickness + differenceOffset, resinThickness + differenceOffset, depth]);
                }
            }
        }
    module innerRoundedShape (){
        union(){
        notRoundedShape();
        translate([resinThickness, resinThickness, 0])fillet(resinThickness, depth);
        translate([10.2, resinThickness, 0])rotate([0, 0, 90])fillet(resinThickness, depth);
        translate([resinThickness, 7 + (resinThickness * 2), 0])rotate([0, 0, 270])fillet(resinThickness, depth);
            }
        }
     module fullyRoundedShaped (){
        difference(){
        innerRoundedShape();
        translate([0, 0, - differenceOffset/2])fillet(resinThickness, depth + differenceOffset);
        translate([10.4, 0, - differenceOffset/2])rotate([0, 0, 90])fillet(resinThickness, depth + differenceOffset);
        translate([0, 7 + (resinThickness * 3), - differenceOffset/2])rotate([0, 0, 270])fillet(resinThickness, depth + differenceOffset);
            }
        }
     module addBatteryHolder (){
         union(){
             fullyRoundedShaped();
             difference(){
                 translate([resinThickness, 2 + resinThickness, resinThickness]){
                    cube([7.5, resinThickness, depth - (resinThickness * 2)]);
                    }
                 translate([resinThickness + 0.4, 2 + resinThickness, resinThickness]){
                    cube([0.3, resinThickness, railsForCircuitHeigth]);
                    }
                 }
             difference(){
                translate([7.5 + resinThickness, resinThickness, resinThickness]){
                    cube([resinThickness, 2 + resinThickness, depth - (resinThickness * 2)]);
                    }
                translate([7.5 + resinThickness, 2 + resinThickness - 0.4, resinThickness]){
                    cube([resinThickness, 0.4, railsForCircuitHeigth]);
                    }
                }
             
             
             railsForProtectionCircuit();
             }
         }
     module addRailsForCircuitBoard(){
         union(){
             addBatteryHolder();
             lowerRailForBoard();
             upperRailForBoard();
             lowerRailForScreen();
             upperRailForScreen();
             }
         }
     module lowerRailForBoard(){
         union(){
            translate([resinThickness, 2 + (resinThickness * 2), resinThickness + railsForCircuitHeigth]){
                cube([4.5, railWidth, resinThickness]);
                }
            translate([resinThickness, 2 + (resinThickness * 2), resinThickness + railsForCircuitHeigth]){
                cube([railWidth, 5, resinThickness]);
                }
            translate([resinThickness, 7 + (resinThickness * 2) - railWidth, resinThickness + railsForCircuitHeigth]){
                cube([4.5, railWidth, resinThickness]);
                }
            }            
        }
    module upperRailForBoard(){
        boardThickness = 0.09;
        translate([0, 0, railWidth + boardThickness]){
            lowerRailForBoard();
            }
        }
    module lowerRailForScreen(){
         union(){
            translate([7.5 + (resinThickness * 2), resinThickness, resinThickness + railsForCircuitHeigth]){
                cube([resinThickness, 2 + resinThickness, resinThickness]);
                }
            translate([7.5 + (resinThickness * 2), resinThickness, resinThickness + railsForCircuitHeigth]){
                cube([10 - 7.5 - resinThickness, resinThickness, resinThickness]);
                }
            translate([10, resinThickness, resinThickness + railsForCircuitHeigth]){
                cube([resinThickness, 2 + resinThickness, resinThickness]);
                }
            }            
        }
    module upperRailForScreen(){
        boardThickness = 0.1;
        translate([0, 0, railWidth + boardThickness]){
            lowerRailForScreen();
            }
        }
    module addPivotPoint(){
        pivotDiameter = 0.2;
        height = 0.2;
        union(){
            addRailsForCircuitBoard();
            translate([0,0,resinThickness])difference(){
                linear_extrude(height){
                    translate([7.5 + (resinThickness * 2), 7 + (resinThickness * 2) - 0.4])circle(pivotDiameter);
                    }
                linear_extrude(height + differenceOffset){
                    offset(-0.1){
                    translate([7.5 + (resinThickness * 2), 7 + (resinThickness * 2) - 0.4])circle(pivotDiameter);
                        }
                    }
                }
                addSwitchMount();
            }
        }
    module railsForProtectionCircuit(){
         railWidth = 0.2;
         protectionBoardWidth = 1.8;
         protectionBoardHeigth = 0.4;
         slotWidth = 0.1;
        difference(){
            union(){
                translate([resinThickness + 7.5 - protectionBoardWidth - railWidth, 2 + (resinThickness * 2), resinThickness]){
                    cube([railWidth, railWidth * 2, protectionBoardHeigth]);
                    }
                translate([resinThickness + 7.5, 2 + (resinThickness * 2), resinThickness]){
                    cube([railWidth, railWidth * 2, protectionBoardHeigth]);
                    }
                }
            union(){
                translate([resinThickness + 7.5 - protectionBoardWidth - railWidth + slotWidth, 2 + (resinThickness * 3), resinThickness]){
                    cube([slotWidth, slotWidth, protectionBoardHeigth + railWidth]);
                    }
                translate([resinThickness + 7.5, 2 + (resinThickness * 3), resinThickness]){
                    cube([slotWidth, slotWidth, protectionBoardHeigth + railWidth]);
                    }
                }
            }        
        }
    module addSwitchMount(){
        module rotate_about_pt(z, y, pt) {
            translate(pt)
                rotate([0, y, z])
                    translate(-pt)
                        children();   
            }
        switchHolesDiamater = 0.2;
        point1X = 0.3364;
        point1Y = 1.4892;
        point2X = 0.9824;
        point2Y = 0.8432;
        cylinderHeight = railsForCircuitHeigth + resinThickness - 0.05;
        baseHeight = 0.3;
        translate([7.5 + (resinThickness * 2) - point1X, 7 + (resinThickness * 2) - 0.4 - point1Y]){
            cylinder(cylinderHeight,switchHolesDiamater/2, switchHolesDiamater/2);
            }
        rotate_about_pt(-24,0,[7.5 + (resinThickness * 2) - point1X, 7 + (resinThickness * 2) - 0.4 - point1Y])translate([7.5 + (resinThickness * 2) - point1X - 0.6, 7 + (resinThickness * 2) - 0.4 - point1Y]){
            cylinder(cylinderHeight,switchHolesDiamater/2, switchHolesDiamater/2);
            }
            
        hull(){
            translate([7.5 + (resinThickness * 2) - point1X, 7 + (resinThickness * 2) - 0.4 - point1Y]){
            cylinder(baseHeight,switchHolesDiamater, switchHolesDiamater);
            }
        rotate_about_pt(-24,0,[7.5 + (resinThickness * 2) - point1X, 7 + (resinThickness * 2) - 0.4 - point1Y])translate([7.5 + (resinThickness * 2) - point1X - 0.6, 7 + (resinThickness * 2) - 0.4 - point1Y]){
            cylinder(baseHeight,switchHolesDiamater, switchHolesDiamater);
            }
            }
         
        }
        addPivotPoint();
}
 
module fillet(r, h) {
    translate([r / 2, r / 2, h/2])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}

module frontWallCasing(){
    module notRoundedShape(){
        difference(){
            union(){
                translate([0,0,0.2])
                difference(){
                    linear_extrude(frontWallCasingDepth){
                        casingBase();
                        }
                    translate([0,0,-differenceOffset])
                    linear_extrude(frontWallCasingDepth - resinThickness + differenceOffset){
                        offset(- resinThickness){
                            casingBase();
                            }
                        }
                    }
                difference(){
                    linear_extrude(frontWallCasingDepth + 0.2){
                        offset(- resinThickness){
                            casingBase();
                            }
                        }
                    translate([0,0,-differenceOffset])
                    linear_extrude(frontWallCasingDepth + 0.2 + differenceOffset){
                        offset(- resinThickness - 0.2){
                            casingBase();
                            }
                        }
                    }
                }
            translate([7.5 + (resinThickness ), 7 + (resinThickness), 0])cube([2.3, 5, resinThickness]);
            }
        }
    module innerRoundedShape(){
        union(){
            notRoundedShape();
            translate([resinThickness * 2, resinThickness * 2,0])
            fillet(resinThickness, frontWallCasingDepth + lockHeigth);
            translate([resinThickness * 2, 7 + (resinThickness),0])rotate([0, 0, -90])
            fillet(resinThickness, frontWallCasingDepth + lockHeigth);
            translate([10, resinThickness * 2,0])rotate([0, 0, 90])
            fillet(resinThickness, frontWallCasingDepth + lockHeigth);     
            }
        }
    module fullyRoundedShape(){
        difference(){
            innerRoundedShape();
            translate([resinThickness, resinThickness, - differenceOffset])
            fillet(resinThickness, resinThickness + differenceOffset);
            translate([resinThickness, 7 + (resinThickness * 2),- differenceOffset])rotate([0, 0, -90])
            fillet(resinThickness, resinThickness + differenceOffset);
            translate([10 + resinThickness, resinThickness,- differenceOffset])rotate([0, 0, 90])
            fillet(resinThickness, resinThickness + differenceOffset);
            }
        }
    module addPivotPoint(){
        pivotDiameter = 0.2;
        height = 0.2;
            translate([0, 0 ,0.3])difference(){
                linear_extrude(height){
                    translate([7.5 + (resinThickness * 2), 7 + (resinThickness * 2) - 0.4])circle(pivotDiameter);
                    }
                linear_extrude(height + differenceOffset){
                    offset(-0.1){
                    translate([7.5 + (resinThickness * 2), 7 + (resinThickness * 2) - 0.4])circle(pivotDiameter);
                    }
                }
            }
        }
    module completeWall(){
        union(){
            fullyRoundedShape();
            addPivotPoint();
            }
        }
        completeWall();
    }
    module door(){
        module ramp(){
            difference(){
                translate([0,0,resinThickness]){
                    cylinder(casingDepth - (resinThickness * 4), 1, 1);
                    }
                translate([-4 - resinThickness/2, -2, 0])cube([4, 4, 4]);
                translate([0, 2, 2])cube([4, 4, 4], true);
                translate([-resinThickness/2, -1,- differenceOffset])rotate([0, 0, 0])
                fillet(resinThickness, 5);
                translate([1, 0,- differenceOffset])rotate([0, 0, 180])
                fillet(resinThickness, 5);     
                }
            }
        module pivot(){
            cylinder(casingDepth - (resinThickness * 2), (resinThickness/2) - 0.01, (resinThickness/2) - 0.01);
            }
        module slab(){
            translate([-resinThickness/2, 0, resinThickness]){
                cube([resinThickness, 2.3, casingDepth - (resinThickness * 4)]);
                }
            }
        union(){
            ramp();
            pivot();
            slab();
            }
        }
    
//lock(7.5, 2.2, 3.8, 0.2);


//translate([-resinThickness, doubleSidedTapeThickness, 10 + (resinThickness * 3) + 0.8 + doubleSidedTapeThickness])rotate([-90, 0, 0])
        backWallCasing(backWallCasingDepth);

//translate([-resinThickness, doubleSidedTapeThickness + 5, 10 + (resinThickness * 3) + 0.8 + doubleSidedTapeThickness])rotate([-90, 0, 0])
        translate([0,0,2.5])frontWallCasing();

translate([7.5 + (resinThickness * 2), 7 + (resinThickness * 2) - 0.4, 0.2])door();   
    
    
    
    
    