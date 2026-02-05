from PIL import Image, ImageDraw, ImageFont
import math, os

BASE_DIR = r"C:\Users\sympo\Downloads\handyman_user_flutter_v11.10.0"
RES_DIR = os.path.join(BASE_DIR, "android", "app", "src", "main", "res")
ASSETS_DIR = os.path.join(BASE_DIR, "assets")

BLUE = (30, 136, 229)
WHITE = (255, 255, 255)
TRANSPARENT = (0, 0, 0, 0)

ICON_SIZES = {
    "mipmap-mdpi": 48, "mipmap-hdpi": 72, "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144, "mipmap-xxxhdpi": 192,
}
FOREGROUND_SIZES = {
    "mipmap-mdpi": 108, "mipmap-hdpi": 162, "mipmap-xhdpi": 216,
    "mipmap-xxhdpi": 324, "mipmap-xxxhdpi": 432,
}

def draw_rounded_rect(draw, xy, radius, fill):
    x0, y0, x1, y1 = xy
    draw.rectangle([x0+radius, y0, x1-radius, y1], fill=fill)
    draw.rectangle([x0, y0+radius, x1, y1-radius], fill=fill)
    draw.pieslice([x0, y0, x0+2*radius, y0+2*radius], 180, 270, fill=fill)
    draw.pieslice([x1-2*radius, y0, x1, y0+2*radius], 270, 360, fill=fill)
    draw.pieslice([x0, y1-2*radius, x0+2*radius, y1], 90, 180, fill=fill)
    draw.pieslice([x1-2*radius, y1-2*radius, x1, y1], 0, 90, fill=fill)

def draw_snowflake(draw, cx, cy, size, color, lw=2):
    arm = size / 2
    bl = arm * 0.35
    bo = arm * 0.55
    for i in range(6):
        a = math.radians(i * 60)
        draw.line([(cx, cy), (cx+arm*math.cos(a), cy+arm*math.sin(a))], fill=color, width=max(1, lw))
        bx, by = cx+bo*math.cos(a), cy+bo*math.sin(a)
        for s in [1, -1]:
            ba = a + s * math.radians(45)
            draw.line([(bx, by), (bx+bl*math.cos(ba), by+bl*math.sin(ba))], fill=color, width=max(1, lw))
    dr = max(1, lw)
    draw.ellipse([cx-dr, cy-dr, cx+dr, cy+dr], fill=color)

def get_font(size):
    for name in ["arialbd.ttf", "arial.ttf", "C:/Windows/Fonts/arialbd.ttf", "C:/Windows/Fonts/arial.ttf"]:
        try:
            return ImageFont.truetype(name, size)
        except Exception:
            pass
    return ImageFont.load_default()

def create_standard_icon(size):
    s = size * 4
    img = Image.new("RGBA", (s, s), TRANSPARENT)
    d = ImageDraw.Draw(img)
    m, r = int(s*0.02), int(s*0.18)
    draw_rounded_rect(d, (m, m, s-m, s-m), r, BLUE)
    draw_snowflake(d, s*0.5, s*0.32, s*0.22, WHITE, max(2, int(s*0.012)))
    f = get_font(int(s*0.30))
    bb = d.textbbox((0,0), "AC", font=f)
    tx, ty = (s-(bb[2]-bb[0]))/2, s*0.52
    so = max(1, int(s*0.008))
    d.text((tx+so, ty+so), "AC", font=f, fill=(20,100,180))
    d.text((tx, ty), "AC", font=f, fill=WHITE)
    return img.resize((size, size), Image.LANCZOS)

def create_round_icon(size):
    s = size * 4
    img = Image.new("RGBA", (s, s), TRANSPARENT)
    d = ImageDraw.Draw(img)
    m = int(s*0.02)
    d.ellipse([m, m, s-m, s-m], fill=BLUE)
    draw_snowflake(d, s*0.5, s*0.32, s*0.20, WHITE, max(2, int(s*0.012)))
    f = get_font(int(s*0.28))
    bb = d.textbbox((0,0), "AC", font=f)
    tx, ty = (s-(bb[2]-bb[0]))/2, s*0.52
    so = max(1, int(s*0.008))
    d.text((tx+so, ty+so), "AC", font=f, fill=(20,100,180))
    d.text((tx, ty), "AC", font=f, fill=WHITE)
    return img.resize((size, size), Image.LANCZOS)

def create_foreground_icon(size):
    s = size * 4
    img = Image.new("RGBA", (s, s), TRANSPARENT)
    d = ImageDraw.Draw(img)
    sm, ss = s*0.1667, s*0.6667
    draw_snowflake(d, s*0.5, sm+ss*0.30, ss*0.24, WHITE, max(2, int(s*0.012)))
    f = get_font(int(ss*0.32))
    bb = d.textbbox((0,0), "AC", font=f)
    tx, ty = (s-(bb[2]-bb[0]))/2, sm+ss*0.48
    so = max(1, int(s*0.006))
    d.text((tx+so, ty+so), "AC", font=f, fill=(20,100,180,120))
    d.text((tx, ty), "AC", font=f, fill=WHITE)
    return img.resize((size, size), Image.LANCZOS)

def create_monochrome_icon(size):
    s = size * 4
    img = Image.new("RGBA", (s, s), TRANSPARENT)
    d = ImageDraw.Draw(img)
    sm, ss = s*0.1667, s*0.6667
    draw_snowflake(d, s*0.5, sm+ss*0.30, ss*0.24, WHITE, max(2, int(s*0.014)))
    f = get_font(int(ss*0.32))
    bb = d.textbbox((0,0), "AC", font=f)
    tx = (s-(bb[2]-bb[0]))/2
    d.text((tx, sm+ss*0.48), "AC", font=f, fill=WHITE)
    return img.resize((size, size), Image.LANCZOS)

def create_background(size):
    return Image.new("RGBA", (size, size), BLUE+(255,))

def main():
    gen = []
    print("=== AC Chill Launcher Icon Generator ===")

    items = [
        ("standard", ICON_SIZES, create_standard_icon, "ic_launcher.png"),
        ("round", ICON_SIZES, create_round_icon, "ic_launcher_round.png"),
        ("foreground", FOREGROUND_SIZES, create_foreground_icon, "ic_launcher_foreground.png"),
        ("background", FOREGROUND_SIZES, create_background, "ic_launcher_background.png"),
        ("monochrome", FOREGROUND_SIZES, create_monochrome_icon, "ic_launcher_monochrome.png"),
    ]
    for label, sizes, creator, fname in items:
        print("Generating " + label + " icons...")
        for density, sz in sizes.items():
            p = os.path.join(RES_DIR, density, fname)
            os.makedirs(os.path.dirname(p), exist_ok=True)
            creator(sz).save(p, "PNG")
            gen.append(p)
            print("  " + density + "/" + fname + " (" + str(sz) + "x" + str(sz) + ")")

    print("Generating app logos...")
    os.makedirs(ASSETS_DIR, exist_ok=True)
    logo = create_standard_icon(192)
    for name in ["app_logo.png", "ic_app_logo.png"]:
        p = os.path.join(ASSETS_DIR, name)
        logo.save(p, "PNG")
        gen.append(p)
        print("  assets/" + name + " (192x192)")

    print("=== Done! Generated " + str(len(gen)) + " icon files. ===")

if __name__ == "__main__":
    main()
