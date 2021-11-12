-- period_busy_wait.adb
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

procedure Period_Busy_Wait is
   procedure Wait_For_Home_Sensor (Value : in Boolean) is
   begin
      while POV_Sim.Home_Sensor /= Value loop
         null;
      end loop;
   end Wait_For_Home_Sensor;

   T_0, T_1 : Time_Span;
   T_Delta  : Time_Span;
begin
   Put_Line ("Starting simulation");
   POV_Sim.Start_Simulation;

   for Iteration in 1 .. 10 loop
      -- Wait for the LED strip to arrive at 0 deg
      Wait_For_Home_Sensor (True);
      T_0 := Clock - POV_Sim.Epoch;
      -- Wait for the LED strip to swing outside 0 deg
      Wait_For_Home_Sensor (False);
      -- Wait for the LED strip to arrive again at 0 deg
      Wait_For_Home_Sensor (True);
      T_1 := Clock - POV_Sim.Epoch;
      -- Calculate time elapsed between two full subsequent rotations
      T_Delta := T_1 - T_0;
      Put_Line ("T_Delta = " & Duration'Image (To_Duration (T_Delta)) & "s");
   end loop;

   Put_Line ("Ending simulation");
   POV_Sim.End_Simulation;
end Period_Busy_Wait;
