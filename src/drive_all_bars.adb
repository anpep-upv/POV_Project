-- drive_all_bars.adb
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

procedure Drive_All_Bars is
   Pattern : constant POV_Sim.Byte := 16#FF#;
   T       : Time;
begin
   Put_Line ("Starting simulation");
   POV_Sim.Start_Simulation;

   for Iteration in 1 .. 10 loop
      -- Wait for the LED strip to arrive at 0 deg
      POV_Sim.Wait_Zero_Crossing (T);

      for Theta in 120 .. 239 loop
         delay until T + Milliseconds (4 * Theta);
         POV_Sim.Drive_LEDs (Pattern);
      end loop;
   end loop;

   POV_Sim.Wait_Zero_Crossing (T);

   Put_Line ("Ending simulation");
   POV_Sim.End_Simulation;
end Drive_All_Bars;
