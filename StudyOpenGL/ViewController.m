//
//  ViewController.m
//  StudyOpenGL
//
//  Created by sogata on 2014/05/15.
//  Copyright (c) 2014年 RICOH. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()
{
    float mTime;
    GLKReflectionMapEffect * mEffect;
    GLuint mBuffer;
    GLuint cBuffer;
}
@end

@implementation ViewController
- (void) viewDidAppear:(BOOL)animated
{
    
    // GLKViewController を使う準備
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor redColor];
    ((GLKView *)self.view).context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //OpenGL ES 2.0になる
    EAGLContext.currentContext = ((GLKView*)self.view).context;
    // 色々考えろ。と伝えている箇所
    ((GLKView*)self.view).drawableDepthFormat = GLKViewDrawableDepthFormat24;
	glEnable( GL_DEPTH_TEST );
  NSArray * paths =
     @[ [ NSBundle.mainBundle pathForResource:@"R" ofType:@"png" ]
        ,	[ NSBundle.mainBundle pathForResource:@"L" ofType:@"png" ]
        ,	[ NSBundle.mainBundle pathForResource:@"T" ofType:@"png" ]
        ,	[ NSBundle.mainBundle pathForResource:@"B" ofType:@"png" ]
        ,	[ NSBundle.mainBundle pathForResource:@"N" ofType:@"png" ]
        ,	[ NSBundle.mainBundle pathForResource:@"F" ofType:@"png" ]
        ];
    GLKTextureInfo * wTI= [GLKTextureLoader cubeMapWithContentsOfFiles:paths
                                                                options:nil
                                                                  error:NULL
                            ];
    assert(wTI);
    
	mEffect = [ [ GLKReflectionMapEffect alloc ] init ];
	mEffect.textureCubeMap.name = wTI.name;
    
    // ------------
    
    static GLfloat sCubeVertexData[ 108 ] =
    {	 1, -1, -1
		,	 1,  1, -1
		,	 1, -1,  1
		,	 1, -1,  1
		,	 1,  1, -1
		,	 1,  1,  1
        
		,	 1,  1, -1
		,	-1,  1, -1
		,	 1,  1,  1
		,	 1,  1,  1
		,	-1,  1, -1
		,	-1,  1,  1
        
		,	-1,  1, -1
		,	-1, -1, -1
		,	-1,  1,  1
		,	-1,  1,  1
		,	-1, -1, -1
		,	-1, -1,  1
        
		,	-1, -1, -1
		,	 1, -1, -1
		,	-1, -1,  1
		,	-1, -1,  1
		,	 1, -1, -1
		,	 1, -1,  1
        
		,	 1,  1,  1
		,	-1,  1,  1
		,	 1, -1,  1
		,	 1, -1,  1
		,	-1,  1,  1
		,	-1, -1,  1
        
		,	 1, -1, -1
		,	-1, -1, -1
		,	 1,  1, -1
		,	 1,  1, -1
		,	-1, -1, -1
		,	-1,  1, -1
    };
    static	GLfloat sCubeNormalData[ 108 ] =
    {	 1,	 0,	 0
		,	 1,	 0,	 0
		,	 1,	 0,	 0
		,	 1,	 0,	 0
		,	 1,	 0,	 0
		,	 1,	 0,	 0
		
		,	 0,	 1,	 0
		,	 0,	 1,	 0
		,	 0,	 1,	 0
		,	 0,	 1,	 0
		,	 0,	 1,	 0
		,	 0,	 1,	 0
        
		,	-1,	 0,	 0
		,	-1,	 0,	 0
		,	-1,	 0,	 0
		,	-1,	 0,	 0
		,	-1,	 0,	 0
		,	-1,	 0,	 0
        
		,	 0,	-1,	 0
		,	 0,	-1,	 0
		,	 0,	-1,	 0
		,	 0,	-1,	 0
		,	 0,	-1,	 0
		,	 0,	-1,	 0
        
		,	 0,	 0,	 1
		,	 0,	 0,	 1
		,	 0,	 0,	 1
		,	 0,	 0,	 1
		,	 0,	 0,	 1
		,	 0,	 0,	 1
        
		,	 0,	 0,	-1
		,	 0,	 0,	-1
		,	 0,	 0,	-1
		,	 0,	 0,	-1
		,	 0,	 0,	-1
		,	 0,	 0,	-1
    };
    glGenBuffers(1, &mBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, mBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sCubeVertexData), sCubeVertexData, GL_STATIC_DRAW);
    
    glGenBuffers(1, &cBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, cBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sCubeNormalData), sCubeNormalData, GL_STATIC_DRAW);
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    // 使い終わったら片付ける
    [super viewWillDisappear:animated];
    mEffect = nil;
    ((GLKView*)self.view).context = nil;
    // -----------
    glDeleteBuffers(1, &mBuffer);
    glDeleteBuffers(1, &cBuffer);
    
}

- (void) update
{
    mTime += self.timeSinceLastUpdate;
}

//GLKBaseEffect を使って３角形を描画する。(3次元にお試し改良)
// http://paraiso.moo.jp/wp/?p=61
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0, 0, 0, 1);
    mEffect.transform.modelviewMatrix = GLKMatrix4Rotate(	GLKMatrix4MakeTranslation( 0, 0, -4 )
                                                                ,	mTime
                                                                ,	-1
                                                                ,	1
                                                                ,	-1
                                                                );
    mEffect.transform.projectionMatrix = GLKMatrix4MakePerspective
	(	GLKMathDegreesToRadians( 90 )
     ,	self.view.bounds.size.width / self.view.bounds.size.height
     ,	1
     ,	100
     );

    [mEffect prepareToDraw];

    [self draw:GLKVertexAttribPosition normal:GLKVertexAttribNormal];
}
- (void) draw:(GLuint) position normal:(GLuint) normal
{
    glBindBuffer( GL_ARRAY_BUFFER, mBuffer );
    glVertexAttribPointer( position, 3, GL_FLOAT, GL_FALSE, 12, 0 );
    
    glBindBuffer( GL_ARRAY_BUFFER, cBuffer );
    glVertexAttribPointer( normal, 3, GL_FLOAT, GL_FALSE, 12, 0 );
    
    glEnableVertexAttribArray( position );
    glEnableVertexAttribArray( normal );
    glDrawArrays( GL_TRIANGLES, 0, 36 );
    glDisableVertexAttribArray( normal );
    glDisableVertexAttribArray( position );
}

@end