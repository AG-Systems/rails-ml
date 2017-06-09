
class Post extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      feedback: 'Loading...',
      calltoaction: 'Loading....'
    };
  }
  componentDidMount() 
  {
      this.setState({feedback: this.props.feed}, function() 
      {
          console.log(this.state.feedback * 100);
      }); 
      this.setState({calltoaction: this.props.calltoaction}, function() 
      {
          console.log(this.state.calltoaction * 10);
      });  
  }
  help()
  {
     document.getElementById("helpfeedback").style.display = "block";
  }
  render() { 
    return(
           <div>
            <div className="card-images"> 
                    <img src={this.props.image} alt={this.props.title} id="pic-image"/>
                    <div className="container-images" s>
                        <h2><b>Title: {this.props.title}</b></h2>
                        <p><b>Feedback: </b></p>
                        <p>Clarity of ad: {this.state.feedback * 100}% <span className="glyphicon glyphicon-question-sign" onClick={this.help}></span></p>
                        <div className="progress">
                          <div className="progress-bar progress-bar-custom" role="progressbar" aria-valuenow={this.state.feedback * 100} 
                          aria-valuemin="0" aria-valuemax="100" style={{width:this.state.feedback * 100 + "%"}}>
                          </div>
                        </div>
                        <p>Ad Memorability: {this.state.calltoaction* 10}% <span className="glyphicon glyphicon-question-sign" onClick={this.help}></span></p>
                        <div className="progress">
                          <div className="progress-bar progress-bar-custom" role="progressbar" aria-valuenow={this.state.calltoaction * 10} 
                          aria-valuemin="0" aria-valuemax="100" style={{width:this.props.calltoaction * 10 + "%"}}>
                          </div>
                        </div>     

                        <p>Attention Grab: {this.props.colorstatus * 10}% <span className="glyphicon glyphicon-question-sign" onClick={this.help}></span></p>
                        <div className="progress">
                          <div className="progress-bar progress-bar-custom" role="progressbar" aria-valuenow={this.props.colorstatus * 10} 
                          aria-valuemin="0" aria-valuemax="100" style={{width:this.props.colorstatus * 10 + "%"}}>
                          </div>
                        </div>                         
                        <p><b>{this.props.status} this ad </b></p>
                        <hr/>
                        <p><b>Overall Rating: {this.props.rating}/10</b></p>
                    </div>
            </div>
            <br/>
        </div>
        )   
  }
}





/*

class Paid extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      feedback: 'Loading...'
    };
  }
  componentDidMount() 
  {
      this.setState({feedback: this.props.feed}, function() 
      {
          console.log(this.state.feedback);
      });   
  }
  render() {
    return(
        <div>
            <div className="card-images">
                <img src={this.props.image} alt={this.props.title} id="ad-image"/>
                <div className="container-images">
                    <h3><b>{this.props.title}</b></h3>
                    <p><b>Feedback: </b></p>
                    {this.state.feedback.split("\n").map(i => {
                          return <p>{i}</p>;
                    })}
                    <hr/>
                    <p><b>Image Recognition:</b></p>
                    {this.props.analysis.split("\n").map(i => {
                          return <p>{i}</p>;
                    })}

                    <hr/>
                    <p>Rating: {this.props.rating}/10</p>
                </div>
            </div>
        </div>
        )   
  }
}



      var that = this;
      fetch("//api.giphy.com/v1/gifs/search?q=$" + that.props.title + "&api_key=dc6zaTOxFJmzC")
        .then(function(response) {
          return response.json()
        }).then(function(json) {
              // console.log('parsed json', json.data[0].images.fixed_height.url)
               that.setState({feedback: json.data[0].images.fixed_height.url}, function () 
               {
                  console.log(that.state.feedback);
                });
        }).catch(function(ex) {
          console.log('parsing failed', ex)
        })
        
  */
  
