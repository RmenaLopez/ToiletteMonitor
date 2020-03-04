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
                    cube([7.5, resinThickness, depth - resinThickness]);
                    }
                 translate([resinThickness + 0.4, 2 + resinThickness, resinThickness]){
                    cube([0.3, resinThickness, railsForCircuitHeigth]);
                    }
                 }
             
             translate([7.5 + resinThickness, resinThickness, resinThickness]){
                 cube([resinThickness, 2 + resinThickness, depth - resinThickness]);
                 }
             railsForProtectionCircuit();
             }
         }
     module addRailsForCircuitBoard(){
         union(){
             addBatteryHolder();
             lowerRailForBoard();
             upperRailForBoard();
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
    module addPivotPoint(){
        union(){
            addRailsForCircuitBoard();
            translate([0,0,resinThickness])difference(){
                linear_extrude(0.2){
                    translate([7.5 + resinThickness + 0.4, 7 + (resinThickness * 2) - 0.4])circle(0.3);
                    }
                linear_extrude(0.2 + differenceOffset){
                    offset(-0.1){
                    translate([7.5 + resinThickness + 0.4, 7 + (resinThickness * 2) - 0.4])circle(0.3);
                        }
                    }
                }
            }
        }
    module railsForProtectionCircuit(){
         railWidth = 0.2;
         protectionBoardWidth = 1.8;
         protectionBoardHeigth = 0.4;
         slothWidth = 0.1;
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
                translate([resinThickness + 7.5 - protectionBoardWidth - railWidth + slothWidth, 2 + (resinThickness * 3), resinThickness]){
                    cube([slothWidth, slothWidth, protectionBoardHeigth + railWidth]);
                    }
                translate([resinThickness + 7.5, 2 + (resinThickness * 3), resinThickness]){
                    cube([slothWidth, slothWidth, protectionBoardHeigth + railWidth]);
                    }
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
        }
    module innerRoundedShape(){
        union(){
            notRoundedShape();
            
            translate([resinThickness * 2, resinThickness * 2,0])
            fillet(resinThickness, frontWallCasingDepth + lockHeigth);
            translate([10, resinThickness * 2,0])rotate([0, 0, 90])
            fillet(resinThickness, frontWallCasingDepth + lockHeigth);
            translate([10, 10 + resinThickness,0])rotate([0, 0, 180])
            fillet(resinThickness, frontWallCasingDepth + lockHeigth);
                    
            }
        }
        innerRoundedShape();
    
    }
//lock(7.5, 2.2, 3.8, 0.2);


//color("white")translate([-resinThickness, doubleSidedTapeThickness, 10 + (resinThickness * 3) + 0.8 + doubleSidedTapeThickness])rotate([-90, 0, 0])
    backWallCasing(backWallCasingDepth);

//color("white")translate([-resinThickness, doubleSidedTapeThickness + 10, 10 + (resinThickness * 3) + 0.8 + doubleSidedTapeThickness])rotate([-90, 0, 0])frontWallCasing();
    
    
    
    
    
    
    
    
    