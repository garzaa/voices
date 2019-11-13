float hash( vec2 p )
{
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 hash2( float n )
{
    return fract(sin(vec2(n,n+1.0))*vec2(13.5453123,31.1459123));
}

// Our valueNoise function will bilinearly interpolate a lattice (aka grid)
// and return a smoothed value. This function will essentially allow us to generate
// 2D static.  Bilinear interpolation basically allows us to transform our 1D hash function to a value based on a 2D grid.
// This will eventually be run through an fbm to help us generate a 
// cloud like pattern.
// For more information about biliear filtering, check out Scratch A Pixel's article.
// http://www.scratchapixel.com/old/lessons/3d-advanced-lessons/interpolation/bilinear-interpolation/
// For more info on Value based noise check this url out
// http://www.scratchapixel.com/old/lessons/3d-advanced-lessons/noise-part-1/creating-a-simple-2d-noise/
float valueNoise( vec2 p )
{
    // i is an integer that allow us to move along grid points.
    vec2 i = floor( p );
    // f will be used as an offset between the grid points.
    vec2 f = fract( p );
    
    // Hermite Curve.
    // The formula 3f^2 - 2f^3 generates an S curve between 0.0 and 1.0.
    // If we factor out the variable f, we get f*f*(3.0 - 2.0*f)
    // This allows us to smoothly interpolate along an s curve between our grid points.
    // To see the S curve graph, go to the following url.
    // https://www.desmos.com/calculator/mnrgw3yias
    f = f*f*(3.0 - 2.0*f);
    
    // Interpolate the along the bottom of our grid.
    float bottomOfGrid =    mix( hash( i + vec2( 0.0, 0.0 ) ), hash( i + vec2( 1.0, 0.0 ) ), f.x );
    // Interpolate the along the top of our grid.
    float topOfGrid =       mix( hash( i + vec2( 0.0, 1.0 ) ), hash( i + vec2( 1.0, 1.0 ) ), f.x );

    // We have now interpolated the horizontal top and bottom grid lines.
    // We will now interpolate the vertical line between those 2 horizontal points
    // to get our final value for noise.
    float t = mix( bottomOfGrid, topOfGrid, f.y );
    
    return t;
}

// fbm stands for "Fractional Brownian Motion".
// Essentially this function calls our valueNoise function multiple
// times and adds up the results.  By adding various frequences of noise 
// at different amplitudes, we can generate a simple cloud like pattern.
float fbm( vec2 uv )
{
    float sum = 0.00;
    float amp = 0.7;
    
    for( int i = 0; i < 4; ++i )
    {
        sum += valueNoise( uv ) * amp;
        uv += uv * 1.2;
        amp *= 0.4;
    }
    
    return sum;
}