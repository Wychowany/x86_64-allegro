 #include <stdlib.h> 
#include <stdio.h>
#include <allegro5/allegro.h>
#include <allegro5/allegro_primitives.h>
#include <allegro5/allegro_native_dialog.h>
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_image.h>
#include <unistd.h>

const int SCREEN_W = 800;
const int SCREEN_H = 800;
long BITMAP_W = 800;
long BITMAP_H = 800;
long padding;
 
 void draw_fractal_colors(int a, int b, int c, ALLEGRO_BITMAP* fractal, ALLEGRO_DISPLAY *display){
	al_flip_display();
	 al_set_target_bitmap(fractal);  // set drawing to fractal bitmap
   
    al_clear_to_color(al_map_rgb(a, b, c));
   
    al_set_target_bitmap(al_get_backbuffer(display));  // back drawing to display
    al_draw_bitmap(fractal,0,0,ALLEGRO_FLIP_VERTICAL);
    al_flip_display();
}


void update_map(ALLEGRO_BITMAP* fractal, ALLEGRO_DISPLAY *display){
    al_flip_display();
    al_set_target_bitmap(fractal);  // set drawing to fractal bitmap   
    al_set_target_bitmap(al_get_backbuffer(display));  // back drawing to display
    al_draw_bitmap(fractal,0,0,ALLEGRO_FLIP_VERTICAL);
    al_flip_display();

}
extern void editFractal(unsigned char* bitmap,long current_zoom,long BITMAP_W, long BITMAP_H, long padding);
 
int main(int argc,char **argv){
    padding = (BITMAP_W * 3)%4;
    ALLEGRO_DISPLAY *display = NULL;
    ALLEGRO_EVENT_QUEUE *event_queue = NULL;
    ALLEGRO_BITMAP *fractal = NULL;
    ALLEGRO_LOCKED_REGION *locked = NULL;
 
    unsigned char* data;
    long current_zoom=1;
    if(!al_init()) {
        fprintf(stderr, "failed to initialize allegro!\n");
        return -1;
    }

    display = al_create_display(SCREEN_W, SCREEN_H);
    if(!display) {
        fprintf(stderr, "failed to create display!\n");
        return -1;
    }
   
    fractal = al_create_bitmap(BITMAP_W, BITMAP_H);
    if(!fractal) {
        fprintf(stderr, "failed to create bouncer bitmap!\n");
        al_destroy_display(display);
        return -1;
    }
    
    
    al_install_keyboard();
    event_queue = al_create_event_queue();
	printf("blabla");
   
    al_register_event_source(event_queue, al_get_keyboard_event_source());
   //draw_fractal_colors(42, 12, 255,fractal,display);
    
   
		
			locked = al_lock_bitmap(fractal, ALLEGRO_PIXEL_FORMAT_BGR_888, ALLEGRO_LOCK_READWRITE);	
			data = locked->data;
                	editFractal(data, current_zoom, BITMAP_W, BITMAP_H, padding);
			al_unlock_bitmap(fractal);
 
     // pointer to bitmap
    
 
    while(1){
	       update_map(fractal,display);
        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);

        if(ev.type == ALLEGRO_EVENT_KEY_DOWN){
            switch(ev.keyboard.keycode){
                case ALLEGRO_KEY_UP:	
			locked = al_lock_bitmap(fractal, ALLEGRO_PIXEL_FORMAT_BGR_888, ALLEGRO_LOCK_READWRITE);	
			current_zoom = current_zoom*2;
			
			if(locked == NULL){
				exit(0);	}
			data = locked->data;
                	editFractal(data, current_zoom, BITMAP_W, BITMAP_H, padding);
			al_unlock_bitmap(fractal);
			
                    	break;
               
                case ALLEGRO_KEY_DOWN:
			if(current_zoom == 1){
				break;}
			locked = al_lock_bitmap(fractal, ALLEGRO_PIXEL_FORMAT_BGR_888, ALLEGRO_LOCK_READWRITE);	
			current_zoom = current_zoom/2;
			
			if(locked == NULL){
				exit(0);	}
			data = locked->data;
                	editFractal(data, current_zoom, BITMAP_W, BITMAP_H, padding);
			al_unlock_bitmap(fractal);
			
                    break;
                   
                case ALLEGRO_KEY_ESCAPE:
                    exit(1);
                    break;
            }
		
        }
    }
   
    return 0;
   
}
