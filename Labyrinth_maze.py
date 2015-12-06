#!/usr/bin/env python

scad = open('Labyrinth_maze.scad','w')
scad.write('matrix = [\n')

file = open('Labyrinth_maze.csv','rU')
lines = file.readlines();
file.close()

lines.pop(0)
for line in lines:
  scad.write('[')
  scad.write(line.strip())
  scad.write('],\n')
scad.write('];\n')
scad.close()

  
