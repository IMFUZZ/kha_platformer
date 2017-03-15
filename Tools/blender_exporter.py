import bpy, json, datetime

# EXPORTER-SPECIFIC SECTION
# ------------------------------------------------------------------------------

PIXEL_PER_UNIT = 32

def get_version_name():
    return datetime.datetime.now().strftime('%y%m%d %H%M%S')

def export_as_scene():
    version = get_version_name()
    scene_data = {
        "version" : datetime.datetime.now().strftime('%y%m%d %H%M%S'),
        "gravity" : 1200,
        "stage" : {}
    }
    elements = []
    for key in bpy.data.objects.keys():
        object = bpy.data.objects.get(key)
        image = None
        if (object.active_material != None and object.active_material.active_texture != None):
            image = object.active_material.active_texture.name
        element = {
            "id": key,
            "location": {
                "x": object.location.x * PIXEL_PER_UNIT,
                "y": object.location.y * PIXEL_PER_UNIT,
            },
            "depth": object.location.z * 32,
            "rotationAngle": -object.rotation_euler.z,
            "dimensions": {
                "width": object.dimensions.x * PIXEL_PER_UNIT,
                "height": object.dimensions.y * PIXEL_PER_UNIT,
            },
            "physics": {
                "physics_type": object.game.physics_type,
            },
            "image": image
        }
        phys_type = object.game.physics_type
        if (phys_type == "CHARACTER"):
            element['physics']["max_jumps"] = object.game.jump_max
            element['physics']["jump_speed"] = object.game.jump_speed
        elif (phys_type == "DYNAMIC"):
            element['physics']["mass"] = object.game.mass
        elements.append(element)
    scene_data['stage']['elements'] = sorted(elements, key=lambda elem: elem['depth'])
    return scene_data

# BLENDER-SPECIFIC SECTION
# ------------------------------------------------------------------------------

def write_some_data(context, filepath, data):
    print("running write_some_data...")
    with open(filepath, 'w', encoding='utf-8') as outfile:
        json.dump(data, outfile)

    return {'FINISHED'}


# ExportHelper is a helper class, defines filename and
# invoke() function which calls the file selector.
from bpy_extras.io_utils import ExportHelper
from bpy.props import StringProperty, BoolProperty, EnumProperty
from bpy.types import Operator


class ExportSomeData(Operator, ExportHelper):
    """This appears in the tooltip of the operator and in the generated docs"""
    bl_idname = "export_test.some_data"  # important since its how bpy.ops.import_test.some_data is constructed
    bl_label = "Export Some Data"

    # ExportHelper mixin class uses this
    filename_ext = ".json"

    filter_glob = StringProperty(
            default="*.json",
            options={'HIDDEN'},
            maxlen=255,  # Max internal buffer length, longer would be clamped.
            )


    type = EnumProperty(
            name="Export type",
            description="Choose between two items",
            items=(('OPT_A', "Export as scene", "Export the following blender scene as a game scene"),
                   ('OPT_B', "Export as asset (COMING SOON)", "(COMING SOON)")),
            default='OPT_A',
            )

    def execute(self, context):
        data = {}
        if self.type == "OPT_A":
            data = export_as_scene()
        return write_some_data(context, self.filepath, data)


# Only needed if you want to add into a dynamic menu
def menu_func_export(self, context):
    self.layout.operator(ExportSomeData.bl_idname, text="Text Export Operator")


def register():
    bpy.utils.register_class(ExportSomeData)
    bpy.types.INFO_MT_file_export.append(menu_func_export)


def unregister():
    bpy.utils.unregister_class(ExportSomeData)
    bpy.types.INFO_MT_file_export.remove(menu_func_export)


if __name__ == "__main__":
    register()

    # test call
    bpy.ops.export_test.some_data('INVOKE_DEFAULT')
