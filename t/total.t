use PDL;
use PDL::HDF5;

# Script to test the PDL::HDF5 objects together in the
#   way they would normally be used
#
#  i.e. not the way they would normally be used as described
#  in the PDL::HDF5 synopsis

print "1..11\n";  

my $testNo = 1;

# New File Check:
my $filename = "newFile.hd5";
# get rid of filename if it already exists
unlink $filename if( -e $filename);

my $hdfobj;
ok($testNo++,$hdfobj = new PDL::HDF5("newFile.hd5"));


# Set attribute for file (root group)
ok($testNo++, $hdfobj->attrSet( 'attr1' => 'dudeman', 'attr2' => 'What??'));

# Try Setting attr for an existing attr
ok($testNo++,$hdfobj->attrSet( 'attr1' => 'dudeman23'));


# Add a attribute and then delete it
ok($testNo++, $hdfobj->attrSet( 'dummyAttr' => 'dummyman', 
				'dummyAttr2' => 'dummyman'));
				
ok($testNo++, $hdfobj->attrDel( 'dummyAttr', 'dummyAttr2' ));


# Get list of attributes
my @attrs = $hdfobj->attrs;
ok($testNo++, join(",",sort @attrs) eq 'attr1,attr2' );




my $group = $hdfobj->group("mygroup");


# Create a dataset in the root group
my $dataset = $hdfobj->dataset;
					
my $pdl = sequence(5,4);


ok($testNo++, $dataset->set($pdl) );
# print "pdl written = \n".$pdl."\n";


my $pdl2 = $dataset->get;
# print "pdl read = \n".$pdl2."\n";

ok($testNo++, (($pdl - $pdl2)->sum) < .001 );


exit;		
##### Stopped Here ####
			
					
# Set attribute for group
ok($testNo++, $group->attrSet( 'attr1' => 'dudeman', 'attr2' => 'What??'));

# Try Setting attr for an existing attr
ok($testNo++,$group->attrSet( 'attr1' => 'dudeman23'));


# Add a attribute and then delete it
ok($testNo++, $group->attrSet( 'dummyAttr' => 'dummyman', 
				'dummyAttr2' => 'dummyman'));
				
ok($testNo++, $group->attrDel( 'dummyAttr', 'dummyAttr2' ));


# Get list of attributes
@attrs = $group->attrs;
ok($testNo++, join(",",sort @attrs) eq 'attr1,attr2' );

# Get a list of datasets (should be none)
my @datasets = $group->datasets;

ok($testNo++, scalar(@datasets) == 0 );

# Create another group
my $group2 = new PDL::HDF5::Group( 'name'=> '/dude2', filename => "newFile.hd5",
					fileID => $hdfobj->{fileID});

# open the root group
my $rootGroup = new PDL::HDF5::Group( 'name'=> '/', filename => "newFile.hd5",
					fileID => $hdfobj->{fileID});

# Get a list of groups
my @groups = $rootGroup->groups;

# print "Root group has these groups '".join(",",sort @groups)."'\n";
ok($testNo++, join(",",sort @groups) eq 'dude,dude2' );


# Get a list of groups in group2 (should be none)
@groups = $group2->groups;

ok($testNo++, scalar(@groups) == 0 );


# Create a dataset in the root group
my $dataset = new PDL::HDF5::Dataset( 'name'=> 'data1', groupname => "dude",
					groupID => $group->{groupID});
					
my $pdl = sequence(5,4);


ok($testNo++, $dataset->set($pdl) );
# print "pdl written = \n".$pdl."\n";


my $pdl2 = $dataset->get;
# print "pdl read = \n".$pdl2."\n";

ok($testNo++, (($pdl - $pdl2)->sum) < .001 );

unlink("newfile.hd5");

print "completed\n";


#  Testing utility functions:
sub ok {
        my $no = shift ;
        my $result = shift ;
        print "not " unless $result ;
        print "ok $no\n" ;
}