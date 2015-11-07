# ##### BEGIN GPL LICENSE BLOCK #####
#
# This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software Foundation,
#  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# ##### END GPL LICENSE BLOCK #####

# <pep8 compliant>

bl_info = {
    "name": "Export Materials to GLSL",
    "author": "Vitor Balbio & Sybren A. Stüvel",
    "version": (1, 1),
    "blender": (2, 6, 0),
    "api": 40838,
    "location": "Material Properties",
    "description": "Export one or more materials to GLSL Code",
    "warning": "",
    "wiki_url": "http://wiki.blender.org/index.php/Extensions:2.5/Py/Scripts/Game_Engine/Export_GLSL",
    "tracker_url": "http://projects.blender.org/tracker/index.php?func=detail&aid=28839&group_id=153&atid=467",
    "category": "Game Engine"}

import bpy
import gpu
import os


class EXPORT_OT_GLSLmat(bpy.types.Operator):
    """Export all materials of this scene to GLSL (.frag and .vert files) """
    bl_idname = "export.glslmat"
    bl_label = "Export Material To GLSL"

    filepath = bpy.props.StringProperty(subtype="FILE_PATH")

    def write_shader(self, scene, mat):
        """Writes a shader for the given material to two GLSL files."""

        shader = gpu.export_shader(scene, mat)

        path = os.path.join(self.filepath, "mat_%s.%%s" % mat.name)
        with open(path % "frag", "w") as frag:
            frag.write(shader["fragment"])

        with open(path % "vert", "w") as vertex:
            vertex.write(shader["vertex"])

        self.export_count += 1

    def execute(self, context):

        scene = bpy.context.scene
        materials = bpy.data.materials
        export_glsl_options = bpy.context.window_manager.exportGlslOptions

        self.filepath = os.path.dirname(self.filepath)
        self.export_count = 0

        print('Writing GLSL files to %s' % self.filepath)

        if export_glsl_options == "ALL":
            for mat in materials:
                self.write_shader(scene, mat)

        elif export_glsl_options == "SELECTED":
            for obj in bpy.context.selected_objects:
                print('   - exporting materials for object %s' % obj)
                for matsl in obj.material_slots:
                    self.write_shader(scene, matsl.material)

        elif export_glsl_options == "ACTIVE":
            self.write_shader(scene, bpy.context.material)

        self.report({'INFO'}, 'Exported %i materials to GLSL files' % self.export_count)

        return {'FINISHED'}

    def invoke(self, context, event):
        context.window_manager.fileselect_add(self)
        return {'RUNNING_MODAL'}


class GlslExportPanel(bpy.types.Panel):
    bl_idname = "Export_Material2GLSL"
    bl_label = "Export Material To GLSL"
    bl_space_type = 'PROPERTIES'
    bl_region_type = 'WINDOW'
    bl_context = "material"

    bpy.types.WindowManager.exportGlslOptions = bpy.props.EnumProperty(
        name="Export",
        description="",
        items=(("ALL", "All Materials", "Export all materials from all scenes"),
               ("SELECTED", "Selected Object Materials ",
                "Export all materials from the selected objects"),
               ("ACTIVE", "Active Material", "Export just this active material")),
        default="ALL")

    def draw(self, context):
        self.layout.prop(context.window_manager, "exportGlslOptions")
        self.layout.operator("export.glslmat")


def register():
    bpy.utils.register_class(EXPORT_OT_GLSLmat)
    bpy.utils.register_class(GlslExportPanel)


def unregister():
    bpy.utils.unregister_class(EXPORT_OT_GLSLmat)
    bpy.utils.unregister_class(GlslExportPanel)
