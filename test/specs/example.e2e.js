describe('should search movies', () => {
  it('should search Men in Black', () => {
    expect($('~Search Movies')).toBeExisting();

    $('~Search Movies').setValue('Men in Black');
    expect($('~title0')).toHaveTextContaining('Men in Black');
    expect($('~title1')).toHaveTextContaining('Men in Black');
    expect($('~title2')).toHaveTextContaining('Men in Black');
    $('~Cancel').touchAction('tap')
  });
    
  it('should search Terminator', () => {
    $('~Search Movies').setValue('Terminator');
    expect($('~Search Movies')).toHaveTextContaining('Terminator');
    expect($('~title0')).toHaveTextContaining('Terminator');
    expect($('~title1')).toHaveTextContaining('Terminator');
    expect($('~title2')).toHaveTextContaining('Terminator');
    $('~Cancel').touchAction('tap')
  });

  it('should search Kindergarten Cop', () => {
    $('~Search Movies').setValue('Kindergarten Cop');
    expect($('~title0')).toHaveTextContaining('Kindergarten Cop');
    $('~Cancel').touchAction('tap')
  });
});

describe('should open movie details', () => {
  it('should open and show details for Jurassic World: Dominion', () => {
    $('~Search Movies').setValue('Jurassic World: Dominion');
    expect($('~title0')).toHaveTextContaining('Jurassic World: Dominion');
    expect($('~overview0')).toHaveTextContaining('Plot unknown');

    $('~title0').touchAction('tap')

    expect($('~title')).toHaveTextContaining('Jurassic World: Dominion');
    expect($('~overview')).toHaveTextContaining('Plot unknown');

    $('~Back').touchAction('tap')
    $('~Cancel').touchAction('tap')
  });

  it('should open and show details for The Shawshank Redemption', () => {
    $('~Search Movies').setValue('The Shawshank Redemption');
    expect($('~title0')).toHaveTextContaining('The Shawshank Redemption');
    expect($('~overview0')).toHaveTextContaining('Framed in the 1940s');

    $('~title0').touchAction('tap')

    expect($('~title')).toHaveTextContaining('The Shawshank Redemption');
    expect($('~overview')).toHaveTextContaining('Framed in the 1940s for the double murder of his wife and her lover');

    $('~Back').touchAction('tap')
    $('~Cancel').touchAction('tap')
  });
});
