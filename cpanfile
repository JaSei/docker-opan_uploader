requires 'perl', '5.010';

requires 'Mojolicious';
requires 'Capture::Tiny';
requires 'Path::Tiny';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
