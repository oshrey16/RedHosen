import re
input_string = 'https://www.mapdevelopers.com/draw-circle-tool.php?circles=%5B%5B300%2C31.5270776%2C34.595017%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5366064%2C34.5917339%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5192307%2C34.5949097%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5177307%2C34.5885582%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5276446%2C34.5853825%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5210233%2C34.6061106%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5234926%2C34.5972915%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5145844%2C34.6001883%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5363503%2C34.5862837%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5275714%2C34.5909185%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5145113%2C34.5930643%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5233646%2C34.5873566%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5321073%2C34.58255%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5164137%2C34.6051235%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5200355%2C34.6003599%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5323634%2C34.593708%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5321439%2C34.588172%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5222305%2C34.5919914%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5374111%2C34.5817776%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5317964%2C34.5979996%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5262362%2C34.6079774%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5249742%2C34.6026559%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5298943%2C34.6055098%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5235841%2C34.6114321%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.528175%2C34.600553%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5051083%2C34.6004887%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5043033%2C34.5947809%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5092062%2C34.5978279%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5335704%2C34.6033211%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5166698%2C34.6143932%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5087671%2C34.5929356%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5327657%2C34.6101446%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5363869%2C34.5970125%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5183527%2C34.5811768%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%2C%5B300%2C31.5204014%2C34.5780869%2C%22%23F20A0A%22%2C%22%23000000%22%2C0.4%5D%5D'

match = re.findall("([0-9]+[.]+[0-9]+)", input_string)
match = [a for a in match if a != "0.4" ]


f = open("outputLocation.txt", "a")

for a in range(0,len(match),2):
    f.write("""Circle(
      circleId: const CircleId("{}"),
      consumeTapEvents: true,
      center: const LatLng({},{}),
      fillColor: Colors.red.shade600.withOpacity(0.6),
      strokeColor: Colors.blue.shade600.withOpacity(0.1),
      radius: radius[const CircleId("{}")]!,
    ),""".format(a,match[a], match[a+1],a)
      )
    print(match[a] + match[a+1])
f.close()