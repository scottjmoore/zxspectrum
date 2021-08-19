import sys
import argparse
import ntpath
import struct

from pathlib import Path
from PIL import Image

parser = argparse.ArgumentParser(description='Convert PNG sprite sheet to binary')
parser.add_argument('-i', '--infile', type=argparse.FileType('rb'),default=sys.stdin)
parser.add_argument('-o', '--outfile', type=argparse.FileType('wb'),default=sys.stdout)
parser.add_argument('-b', '--bpp',  type=int,default=1)
parser.add_argument('-sw', '--spritewidth', type=int,default=8)
parser.add_argument('-sh', '--spriteheight', type=int,default=8)
args = parser.parse_args()

filename = Path(ntpath.basename(args.outfile.name)).stem

sprite_width = args.spritewidth
sprite_height = args.spriteheight

image = Image.open(args.infile)
image_name = filename
image_bpp = args.bpp
image_width,image_height = image.size
image_frames = image_height // sprite_height

print("png2bin: '"+args.infile.name+"' => '"+args.outfile.name+"'")
print("\tSprite size  : "+f'{sprite_width}'+"x"+f'{sprite_height}')
print("\tImage bpp    : "+f'{image_bpp}')
print("\tImage size   : "+f'{image_width}'+"x"+f'{image_height}')
print("\tImage frames : "+f'{image_frames}')
print()

f_out = args.outfile

image_pixels = image.load()

x = 0
y = 0

if (image_bpp == 1):
    while y < image_height:

        x = 0
        s = 0
        m = 255
        while x < image_width:
            b = image_pixels[x,y]

            p = 1 << (7 - (x % 8))

            if (b == 1):
                s |= p

            if (b == 2):
                m ^= p
            
            if (p == 1):
                # print(f'{m:>08b}', end = '')
                f_out.write(struct.pack('=B',m))
                f_out.write(struct.pack('=B',s))
                s = 0
                m = 255

            x += 1

        # if ((y % sprite_height) == (sprite_height - 1)):
        #     print()
        # print()

        y += 1

f_out.close()