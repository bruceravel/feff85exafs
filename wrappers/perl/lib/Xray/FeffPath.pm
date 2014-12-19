package Xray::FeffPath;

use Moose;
use Xray::FeffPathWrapper;
use List::MoreUtils qw(any);

has 'wrapper' => (is => 'ro', isa => 'Xray::FeffPathWrapper', default => sub{ Xray::FeffPathWrapper::FEFFPATH->new() });

## simple scalars
has 'phpad'   => (is => 'rw', isa => 'Str',  default => 0,   trigger => sub{pushback(@_, 'phpad'  )},);
has 'Index'   => (is => 'rw', isa => 'Int',  default => 0,   trigger => sub{pushback(@_, 'Index'  )},);
has 'nleg'    => (is => 'rw', isa => 'Int',  default => 0,   trigger => sub{pushback(@_, 'nleg'   )},);
has 'degen'   => (is => 'rw', isa => 'Num',  default => 1.0, trigger => sub{pushback(@_, 'degen'  )},);
has 'iorder'  => (is => 'rw', isa => 'Int',  default => 0,   trigger => sub{pushback(@_, 'iorder' )},);
has 'nnnn'    => (is => 'rw', isa => 'Bool', default => 0,   trigger => sub{pushback(@_, 'nnnn'   )},);
has 'json'    => (is => 'rw', isa => 'Bool', default => 0,   trigger => sub{pushback(@_, 'json'   )},);
has 'verbose' => (is => 'rw', isa => 'Bool', default => 0,   trigger => sub{pushback(@_, 'verbose')},);
has 'ipol'    => (is => 'rw', isa => 'Bool', default => 0,   trigger => sub{pushback(@_, 'ipol'   )},);
has 'elpty'   => (is => 'rw', isa => 'Num',  default => 0.0, trigger => sub{pushback(@_, 'elpty'  )},);
has 'ne'      => (is => 'rw', isa => 'Int',  default => 0,   trigger => sub{pushback(@_, 'ne'     )},);

has 'errorcode'    => (is => 'rw', isa => 'Int',  default => 0,);
has 'errormessage' => (is => 'rw', isa => 'Str',  default => q{},);

has 'edge'    => (is => 'rw', isa => 'Num',  default => 1.0, trigger => sub{pushback(@_, 'edge'    )},);
has 'gam_ch'  => (is => 'rw', isa => 'Num',  default => 1.0, trigger => sub{pushback(@_, 'gam_ch'  )},);
has 'kf'      => (is => 'rw', isa => 'Num',  default => 1.0, trigger => sub{pushback(@_, 'kf'      )},);
has 'mu'      => (is => 'rw', isa => 'Num',  default => 1.0, trigger => sub{pushback(@_, 'mu'      )},);
has 'rnorman' => (is => 'rw', isa => 'Num',  default => 1.0, trigger => sub{pushback(@_, 'rnorman' )},);
has 'version' => (is => 'rw', isa => 'Str',  default => 1.0, trigger => sub{pushback(@_, 'version' )},);
has 'exch'    => (is => 'rw', isa => 'Str',  default => 1.0, trigger => sub{pushback(@_, 'exch'    )},);
has 'rs_int'  => (is => 'rw', isa => 'Num',  default => 1.0, trigger => sub{pushback(@_, 'rs_int'  )},);
has 'vint'    => (is => 'rw', isa => 'Num',  default => 1.0, trigger => sub{pushback(@_, 'vint'    )},);
has potentials => (traits  => ['Array'],
		   is      => 'rw',
		   isa     => 'ArrayRef[ArrayRef]',
		   default => sub { [] },
		  );

## arrays
has 'evec'    => (traits  => ['Array'],
		  is      => 'rw',
		  isa     => 'ArrayRef[Num]',
		  default => sub { [0,0,0] },
		  trigger => \&evec_set,
		 );
has 'xivec'   => (traits  => ['Array'],
		  is      => 'rw',
		  isa     => 'ArrayRef[Num]',
		  default => sub { [0,0,0] },
		  trigger => \&xivec_set);

has 'ipot'     => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Int]', default => sub { [] },
		   handles => {clear_ipot => 'clear', push_ipot  => 'push', });
has 'rat'      => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[ArrayRef[Num]]', default => sub { [] },
		   handles => {clear_rat => 'clear', push_rat  => 'push', });
has 'iz'       => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Int]', default => sub { [] },
		   handles => {clear_iz => 'clear', push_iz  => 'push', });

has 'ri'       => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_ri => 'clear', push_ri  => 'push', });
has 'beta'     => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_beta => 'clear', push_beta  => 'push', });
has 'eta'      => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_eta => 'clear', push_eta  => 'push', });

has 'k'        => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_k => 'clear', push_k  => 'push', });
has 'real_phc' => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_real_phc => 'clear', push_real_phc  => 'push', });
has 'mag_feff' => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_mag_feff => 'clear', push_mag_feff  => 'push', });
has 'pha_feff' => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_pha_feff => 'clear', push_pha_feff  => 'push', });
has 'red_fact' => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_red_fact => 'clear', push_red_fact  => 'push', });
has 'lam'      => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_lam => 'clear', push_lam  => 'push', });
has 'rep'      => (traits  => ['Array'], is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] },
		   handles => {clear_rep => 'clear', push_rep  => 'push', });

sub BUILD {
  my ($self) = @_;
  $self->create_path;
  return $self;
};

sub DEMOLISH {
  my ($self) = @_;
  #print "in my DEMOLISH\n";
  #print $self->wrapper, $/;
  $self->wrapper->cleanup;
  return $self;
};

## this is the trigger for all the scalar-valued attributes.  it pushes the value back to the wrapper object.
sub pushback {
  my ($self, $new, $old, $which) = @_;
  return if (any {$_ eq $which} qw(nleg ne edge gam_ch kf mu rnorman version exch rs_int vint));
  my $method = join("_", "swig", lc($which), "set");
  if ($self->meta->get_attribute($which)->type_constraint eq 'Num') {
    $self->wrapper->$method(1.0*$new);
  } else {
    $self->wrapper->$method($new);
  };
  $self->ipol(1) if (($which eq 'elpty') and $self->wrapper->swig_elpty_get);
};

## these set the 3-element vectors for polarization and ellipticity
sub evec_set {
  my ($self, $new, $old) = @_;
  $self->wrapper->set_evec(0, $new->[0]);
  $self->wrapper->set_evec(1, $new->[1]);
  $self->wrapper->set_evec(2, $new->[2]);
  $self->ipol($new->[0] or $new->[1] or $new->[2]);
  return $self;
};
sub xivec_set {
  my ($self, $new, $old) = @_;
  $self->wrapper->set_xivec(0, $new->[0]);
  $self->wrapper->set_xivec(1, $new->[1]);
  $self->wrapper->set_xivec(2, $new->[2]);
  $self->ipol($new->[0] or $new->[1] or $new->[2]);
  return $self;
};


sub create_path {
  my ($self) = @_;
  $self->wrapper->create_path;
  foreach my $att (qw(Index nleg degen iorder nnnn json verbose ipol elpty)) {
    my $method = join("_", "swig", lc($att), "get");
    $self->$att($self->wrapper->$method||0);
  };
  return $self;
};

sub atom {
  my ($self, $x, $y, $z, $ip) = @_;
  my $message;
  my $ret = $self->wrapper->add_scatterer($x, $y, $z, $ip);
  $self->errorcode($ret);
  $self->errormessage($self->wrapper->swig_errormessage_get);
  $self->nleg($self->wrapper->swig_nleg_get);
  $self->push_ipot($ip);
  $self->push_rat([$x, $y, $z]);
  return $self;
};

sub path {
  my ($self) = @_;
  my $message;
  $|=1;
  my $ret = $self->wrapper->make_path();
  $self->errorcode($ret);
  $self->errormessage($self->wrapper->swig_errormessage_get);

  foreach my $att (qw(version exch edge gam_ch kf mu rnorman rs_int vint)) {
    my $method = join('_', 'swig', $att, 'get');
    $self->$att($self->wrapper->$method);
  };

  ## clear out all the arrays
  $self->ne($self->wrapper->swig_ne_get);
  $self->clear_iz;
  $self->clear_ri;
  $self->clear_beta;
  $self->clear_eta;
  $self->clear_k;
  $self->clear_real_phc;
  $self->clear_mag_feff;
  $self->clear_pha_feff;
  $self->clear_red_fact;
  $self->clear_lam;
  $self->clear_rep;
  ## fill with the results of the calculation
  for my $i (0 .. $Xray::FeffPathWrapper::nphx) {
    $self->push_iz($self->wrapper->get_iz($i));
  };
  for my $i (0 .. $self->nleg-1) {
    $self->push_ri($self->wrapper->get_ri($i));
    $self->push_beta($self->wrapper->get_beta($i));
    $self->push_eta($self->wrapper->get_eta($i));
  };
  my $trinket;
  for my $i (0 .. $self->ne-1) {
    $self->push_k($self->wrapper->get_k($i));
    $self->push_real_phc($self->wrapper->get_real_phc($i));
    $self->push_mag_feff($self->wrapper->get_mag_feff($i));
    $self->push_pha_feff($self->wrapper->get_pha_feff($i));
    $self->push_red_fact($self->wrapper->get_red_fact($i));
    $self->push_lam($self->wrapper->get_lam($i));
    $self->push_rep($self->wrapper->get_rep($i));
  };
  #edge gam_ch kf mu rnorman version exch rs_int vint
  return $self;
};

sub clear {
  my ($self) = @_;
  $self->evec([0,0,0]);
  $self->xivec([0,0,0]);
  $self->clear_iz;
  $self->clear_ri;
  $self->clear_beta;
  $self->clear_eta;
  $self->clear_k;
  $self->clear_real_phc;
  $self->clear_mag_feff;
  $self->clear_pha_feff;
  $self->clear_red_fact;
  $self->clear_lam;
  $self->clear_rep;
  ## occassional failure to call this method
  $self->wrapper->clear_path;
  foreach my $att (qw(Index nleg degen iorder nnnn json verbose ipol elpty)) {
    my $method = join("_", "swig", lc($att), "get");
    $self->$att($self->wrapper->$method||0);
  };
};


sub clean {
  my ($self) = @_;
  $self->wrapper->cleanup;
};

# use Term::ANSIColor qw(:constants);
# sub trace {
#   my ($self) = @_;
#   my $max_depth = 30;
#   my $i = 0;
#   my $base = substr($INC{'Demeter.pm'}, 0, -10);
#   my ($green, $red, $yellow, $end) = (BOLD.GREEN, BOLD.RED, BOLD.YELLOW, RESET);
#   local $|=1;
#   print($/.BOLD."--- Begin stack trace ---$end\n");
#   while ( (my @call_details = (caller($i++))) && ($i<$max_depth) ) {
#     (my $from = $call_details[1]) =~ s{$base}{};
#     my $line  = $call_details[2];
#     my $color = RESET.YELLOW;
#     (my $func = $call_details[3]) =~ s{(?<=::)(\w+)\z}{$color$1};
#     print("$green$from$end line $red$line$end in function $yellow$func$end\n");
#   }
#   print(BOLD."--- End stack trace ---$end\n");
#   return $self;
# };



no Moose;
__PACKAGE__->meta->make_immutable;


=head1 NAME

Xray::FeffPath - SWIG-based interface to libfeffpath

=head1 VERSION

1.00

=head1 SYNOPSIS

This provides a simple object oriented interface to the C<feffpath>
wrapper around Feff's C<onepath> subroutine.  C<onepath> combines the
F-matrix calculation in F<GENFMT/genfmt.f> with the construction of the
common presentation of F-effective from F<FF2X/feffdt.f>.

Given the geometry of a scattering path in the form of Cartesian
coordinates of atoms making up the path, along with some additional
information such as the degeneracy, compute F-effective for that
scattering path.

This replaces the need to read a F<feffNNNN.dat> file.  Given a
scattering geometry, the equivalent data can be computed directly.

The following computes the columns of the F<feff0004.dat> file for
copper metal:

  #!/usr/bin/perl
  use strict;
  use warnings;
  use Xray::FeffPath;

  my $path = Xray::FeffPath->new();
  $path->degen(48);
  $path->Index(4);
  $path->phpad('../fortran/phase.pad');
  $path->atom(0, 0, -3.61, 1);
  $path->atom(-1.805, 0, -1.805, 1);
  $path->path;
  my @kgrid  = @{ $path->k };
  my @caps   = @{ $path->real_phc };
  my @amff   = @{ $path->mag_feff };
  my @phff   = @{ $path->pha_feff };
  my @redfac = @{ $path->red_fact };
  my @lambda = @{ $path->lam };
  my @rep    = @{ $path->rep };
  undef $path

=head1 INSTALLATION

After you have built and installed I<feff85exafs>, do the following:

  perl Makefile.PL
  make
  make test
  sudo make install

That's it!  Note, though, that building this wrapper B<requires> that
the fortran and C code I<feff85exafs> be completely compiled and thet
the resulting libraries (and other files) be successfully installed.

=head1 METHODS

=over 4

=item C<new>

Create the FeffPath object

   my $path = Xray::FeffPath->new();

=item C<atom>

Add an atom to the scattering path, supplying the Cartesian
coordiantes of the atom and its unique potential index.

   $nleg = $path->atom($x, $y, $z, $ipot);

This returns the current number of legs in the path.  To make a SS
paths do:

   $path->atom($x,  $y,  $z, $ipot1);
   print $path->nleg, $/;
   #   ==prints===> 2

To make a MS paths do:

   $path->atom($x1, $y1, $z1, $ipot1);
   $path->atom($x2, $y2, $z2, $ipot2);
   $path->atom($x3, $y3, $z3, $ipot3);
   print $path->nleg, $/;
   #   ==prints===> 4

Note that there is no setter method for the nleg attribute.  Rather,
C<nleg> is incremented by each call to the C<atom> method.

=item C<path>

Compute the scattering path

   $path->path;

=item C<clear>

Reinitialize the scattering path

   $path->clear;

=item C<clear>

Destroy the scattering path, freeing the memory used by the library

   $path->clean;

=back

=head1 ATTRIBUTES

Each of the members of the FEFFPATH struct is wrapped in a getter
method of the same name.  Each of the following exists:

=head2 Scalar valued attributes

=over 4

=item C<phpad> (character, default = phase.pad)

The path to the F<phase.pad> file.  This gets right-padded with spaces
to 256 characters, which is the length of the parameter in the
underlying Fortran library.  Therefore, the value returned by the
getter will be right-padded.

=item C<Index> (integer, default = 9999)

The path index, used for form the name of the output F<feffNNNN.dat>
file.

Accessing this and other scalar-values attributes works in the typical
Moose-y way:

   $path->Index(4);
   print $path->Index, $/;
   ## ==prints==> 4

Note that this attribute (but only this one) is capitalized to avoid
confusion with the built-in C<index> function.

=item C<degen> (float, default = 0)

The path degeneracy.  This is required input for a calculation.

=item C<nleg> (integer, default = 0)

The number of legs in the path.  This should never be set by hand.  It
gets incremented by calls to the C<atom> method.

=item C<iorder> (integer, default = 2)

Order of approximation for multiple scattering paths.

=item C<nnnn> (boolean, default = 0)

Flag for writing F<feffNNNN.dat> file.

=item C<json> (boolean, default = 0)

Flag for writing F<feffNNNN.json> file.

=item C<verbose> (integer, default = 0)

Flag for writing screen messages as files are written.

=item C<ipol> (boolean, default = 0)

Perform polarization calculation.  This gets toggled to true whenever
any of C<elpty>, C<evec>, or C<xivec> are set.

=item C<elpty> (integer, default = 0)

Ellipticity for use in polarization calculation.

=item C<reff> (float, default = 0)

Half path length.  This should never be set by hand.  It
gets set correctly when the C<path> method is called.

=item C<ne> (integer, default = 0)

Number of outpit k grid point.  This should never be set by hand.  It
gets set correctly when the C<path> method is called.

=back

=head2 Error reporting

=over 4

=item C<errorcode> (integer)

An integer error code from either C<atom> or C<path>.  Check for
non-zero value.  For a non-zero return from C<atom>, calling C<path>
is likely to cause a problem in the genfmt calculation.  For a
non-zero return from C<path>, the genfmt calculation was skipped.  See
C<errormessage> for an explanation of the problem.

=item C<errormessage> (string)

A explanation of words of the problem found during C<atom> or C<path>.

   $path->degen(-48);
   $path->atom(0, 0, 3.61, 1);
   $path->path;
   if ($path->errorcode) {
      print $path->errormessage;
   };
   ## ==prints==>
    Error in make_path
        path degeneracy (-48.00) is negative

=back

=head2 Attributes related to the potential model

Several parameters are captured by the C struct (and therefore
available via the perl wrapper) which are related to how Feff's
potential model was calculated.

=over 4

=item  C<version> 

A string identifying the version number and the `feffpath` wrapper
revision.

=item  C<exch>

A string identifying the type of potential model used.  The
possibilities are

  H-L exch (the default)
  D-H exch
  Gd state
  DH - HL
  DH + HL
  val=s+d
  sigmd(r)
  sigmd=c

See the description of the EXCHANGE keyword in the Feff document
L<http://feffproject.org/feff/Docs/feff9/feff90/feff90_users_guide.pdf>
at page 92.

=item  C<edge>

A poor estimate of the energy threshold relative to the atomic value, in eV.

=item  C<gam_ch>

The core-hole lifetime, in eV.

=item  C<kf>

The k value at the Fermi energy, in inverse Angstroms.

=item  C<mu>

The Fermi energy, in eV.

=item  C<rnorman>

The average Norman radius.

=item  C<rs_int>

An estimate of the interstitial radius.

=item  C<vint>

The interstitial potential, in eV.

=back

=head2 Array reference valued attributes

=over 4

=item C<ipot>

A list of the unique potentials of the scatterers in a path.  This is
populated by the calls to the C<atom> method.

=item C<rat>

A list of lists of the Cartesian coordinates of the scatterers in a
path.  This is populated by the calls to the C<atom> method.

=item C<evec>

The electric vector of the incident beam for the polarization
calculation.  Note that the setter's argument is an array reference as
is the getter's return value.

    $path->evec([0,0,1]);
    $evec_ref = $path->evec;
    print join(", ", @$evec_ref);
    ## ==prints==> 0, 0, 1

Setting C<evec> will also set C<ipol> to true.

=item C<xivec>

The Poynting vector of the incident beam for the ellipticity
calculation.  Note that the setter's argument is an array reference as
is the getter's return value.

    $path->xivec([1,1,0]);
    $xivec_ref = $path->xivec;
    print join(", ", @$xivec_ref);
    ## ==prints==> 1, 1, 0

Setting C<xivec> will also set C<ipol> to true.

=item C<ri>

The leg lengths (in Angstroms) of the specified path.  This gets set
when C<path> is called.  It returns an reference to an array with
C<nleg> elements.

=item C<beta>

The Eulerian beta angles (in degrees) of the specified path.  This
gets set when C<path> is called.  It returns a reference to an array
with C<nleg> elements.

=item C<eta>

The Eulerian eta angles (in degrees) of the specified path.  This gets
set when C<path> is called.  It returns a reference to an array with
C<nleg> elements.

=item C<k>

A reference to an array containing the k grid of the calculation.
This is column 1 from F<feffNNNN.dat>.

=item C<real_phc>

A reference to an array containing the central atom phase shifts.
This is column 2 from F<feffNNNN.dat>.

=item C<mag_feff>

A reference to an array containing the magnitude of F-effective.  This
is column 3 from F<feffNNNN.dat>.

=item C<pha_feff>

A reference to an array containing the phase of F-effective.  This is
column 4 from F<feffNNNN.dat>.

=item C<red_fact>

A reference to an array containing the reduction factor.  This is
column 5 from F<feffNNNN.dat>.

=item C<lam>

A reference to an array containing lambda, the mean free path.  This is
column 6 from F<feffNNNN.dat>.

=item C<rep>

A reference to an array containing the real part of the complex
momentum.  This is column 7 from F<feffNNNN.dat>.

=back

=head1 Error codes

The error codes returned by the C<atom> and C<path> methods are the
sums of the codes actually found by the method call, thus the returned
error codes are meant to be interpreted bitwise.

=head2 C<atom> method

If any of these are triggered, it is very likely that a call to
C<path> will return unreliable results or may crash the program.

=over 4

=item I<1>

ipot argument to add_scatterer is less than 0

=item I<2>

ipot argument to add_scatterer is greater than 7

=item I<4>

coordinates are for an atom too close to the previous atom in the path

=item I<8>

nlegs greater than legtot

=back

=head2 C<path> method

If any of these are triggered, genfmt will not be called and all
output arrays will be zero-filled.

=over 4

=item I<1>

the first atom specified is the absorber

=item I<2>

the last atom specified is the absorber

=item I<4>

path degeneracy is negative

=item I<8>

path index not between 0 and 9999

=item I<16>

ellipticity not between 0 and 1

=item I<32>

iorder not between 0 and 10

=item I<64>

F<phase.pad> cannot be found or cannot be read

=back

=head1 EXTERNAL DEPENDENCIES

=over 4

=item *

L<Moose>

=back

=head1 BUGS AND LIMITATIONS

=over 4

=item *

The muffin tin and Norman radii (and ionizations) of the unique
potentials are not captured.

=back

Please report problems to Bruce Ravel (bravel AT bnl DOT gov)

Patches are welcome.

=head1 AUTHOR

Bruce Ravel (bravel AT bnl DOT gov)

L<https://github.com/bruceravel>

=head1 LICENSE AND COPYRIGHT

To the extent possible, the authors have waived all rights granted by
copyright law and related laws for the code and documentation that
make up the Perl Interface to the feffpath library.  While information
about Authorship may be retained in some files for historical reasons,
this work is hereby placed in the Public Domain.  This work is
published from: United States.

Note that the feffpath and onepath libraries themselves are NOT public
domain, nor is the Fortran source code for Feff that it relies upon.

Author: Bruce Ravel (bravel AT bnl DOT gov).
Last update: 4 November, 2014

=cut
