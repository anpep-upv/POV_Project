-- period_suspension.adb
-- Copyright (c) 2021 Ángel Pérez <aperpor@upv.edu.es>
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

with POV_Sim;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;   use Ada.Text_IO;

procedure Period_Suspension is
   T_0, T_1 : Time;
   T_Delta  : Time_Span;
begin
   Put_Line ("Starting simulation");
   POV_Sim.Start_Simulation;

   for Iteration in 1 .. 10 loop
      -- Wait for the LED strip to arrive at 0 deg
      POV_Sim.Wait_Zero_Crossing (T_0);
      -- Wait for the LED strip to arrive at 0 deg again
      POV_Sim.Wait_Zero_Crossing (T_1);
      -- Compute period
      T_Delta := T_1 - T_0;
      Put_Line ("T_Delta = " & To_Duration (T_Delta)'Image & "s");
   end loop;

   Put_Line ("Ending simulation");
   POV_Sim.End_Simulation;
end Period_Suspension;
