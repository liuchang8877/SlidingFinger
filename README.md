 SlidingFinger
--------------
SlidingFinger is base on the 'DroppableView'


I just add 

1.the picture on the back of the view

2.add the the game score

3.add the lefttime of the game

4.save the game path

I have move out the view add and delete method

//--- 2012.12.3
SlidingFinger is a puzzle game, through the image splicing, 
make children's external things have a more intuitive concept, 
in order to develop the children's intelligence development.

I am so glad to see  you can use my code for your app.

                                  Thank you.
                                  liu   (liuchang8877@gmail.com)
                                  2012.11.22
below is the ` DroppableView`  ReadMe.
--------------
A ` DroppableView` represents a single draggable View. You may use it as a base class for the views, that you need to be draggable in your project. Currently it is built, to be used within a scrollView. But this could easily be changed.

The demo app demonstrates, how the `DroppableView` may be used in a project.
The `DroppableView` is used as a subview of a `UIScrollView` and can be dragged within and also out of the scrollview.

### Usage

Initalize the DroppableView like in th following example:  

- `aScrollView` is the parent scrollView
- `target` is a view outside of the scrollview, to where the element should be dragged.

`- (id) initWithScrollView: (UIScrollView *) aScrollView andDropTarget: (UIView *) target;`

and add it as a subview to your `UIScrollView`.  
**Note**: Your `UIScrollView` needs to set `canCancelContentTouches = NO;`.

### Screenshot of the example app:

The black cards can be dragged from the red scrollView onto the green circle.  
Try it!

  
![Screenshot](http://firefrog-wordpress.stor.sinaapp.com/uploads/2012/11/iOS-Simulator-Screen-shot-2012-11-22-%E4%B8%8B%E5%8D%883.22.56.png)